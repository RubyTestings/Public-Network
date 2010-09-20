require 'active_record'
require 'active_record/fixtures'

namespace :db do
  DATA_DIRECTORY = "#{RAILS_ROOT}/lib/tasks/sample_data"
  namespace :sample_data do
    TABLES = %w(users specs faqs)
    MIN_USER_ID = 1000 #starting user id for sample data

    # THis part can be rewrited in a way
    # check list of files in a folder
    # check whether the file name can be associated with any table
    # if so try to load file
    desc "Load sample data"
    task :load => :environment do |t|
      class_name =  nil #use nil to get rails to gigure out the class
      TABLES.each do |table_name|
        fixture = Fixtures.new(ActiveRecord::Base.connection,
                               table_name, class_name,
                               File.join(DATA_DIRECTORY, table_name.to_s))
        fixture.insert_fixtures
        puts "Loaded data from #{table_name}.yml"
      end
    end

    # This part can also be rewrited
    # the logic once again is simple
    # check file list in folder
    # check whether the appropriate table exist
    # delete any record in such table starting from selected id
    # + some logic to chose between user_id and id
    desc "Remove sample data"
    task :delete => :environment do |t|
      User.delete_all("id >= #{MIN_USER_ID}")
      Spec.delete_all("user_id >= #{MIN_USER_ID}")
      Faq.delete_all("user_id >= #{MIN_USER_ID}")
    end

  end
end