class CreateGeoData < ActiveRecord::Migration
  def self.up
    
    table_name = :geo_data
    
    create_table table_name do |t|
      t.column  :zip_code, :string
      t.column  :latitude, :float
      t.column  :longitude, :float
      t.column  :city, :string
      t.column  :state, :string
      t.column  :county, :string
      t.column  :type, :string
    end
    
    add_index "geo_data", ["zip_code"], :name => "zip_code_optimization"
    
    file = "#{RAILS_ROOT}/db/geo_data/ZIP_CODES.txt"
    fields = '(zip_code, latitude, longitude, city, state, county)'
    
    execute "LOAD DATA LOCAL INFILE '#{file}' INTO TABLE #{table_name.to_s} "+
            "FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY \"\"\"\" " +
            "LINES TERMINATED BY '\n' " + fields
    
  end

  def self.down
  end
end
