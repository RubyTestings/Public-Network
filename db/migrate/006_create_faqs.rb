class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.column    :user_id,  :integer, :null => false
      t.column    :bio,      :text
      t.column    :education,   :text
      t.column    :skills,   :text
      t.column    :projects, :text
      t.column    :prizes,   :text
      t.column    :interests,:text
    end
  end

  def self.down
    drop_table :faqs
  end
end
