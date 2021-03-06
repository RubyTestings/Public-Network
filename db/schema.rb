# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 6) do

  create_table "faqs", :force => true do |t|
    t.column "user_id",   :integer, :null => false
    t.column "bio",       :text
    t.column "education", :text
    t.column "skills",    :text
    t.column "projects",  :text
    t.column "prizes",    :text
    t.column "interests", :text
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specs", :force => true do |t|
    t.column "user_id",    :integer,                 :null => false
    t.column "first_name", :string,  :default => ""
    t.column "last_name",  :string,  :default => ""
    t.column "gender",     :string
    t.column "birthdate",  :date
    t.column "occupation", :string,  :default => ""
    t.column "city",       :string,  :default => ""
    t.column "state",      :string,  :default => ""
    t.column "zip_code",   :string,  :default => ""
  end

  create_table "users", :force => true do |t|
    t.column "screen_name",         :string
    t.column "email",               :string
    t.column "password",            :string
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
    t.column "authorization_token", :string
  end

end
