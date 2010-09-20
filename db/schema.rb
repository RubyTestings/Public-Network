# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100918110947) do

  create_table "faqs", :force => true do |t|
    t.integer "user_id",   :null => false
    t.text    "bio"
    t.text    "education"
    t.text    "skills"
    t.text    "projects"
    t.text    "prizes"
    t.text    "interests"
  end

  create_table "geo_data", :force => true do |t|
    t.string "zip_code"
    t.float  "latitude"
    t.float  "longitude"
    t.string "city"
    t.string "state"
    t.string "county"
    t.string "type"
  end

  add_index "geo_data", ["zip_code"], :name => "zip_code_optimization"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specs", :force => true do |t|
    t.integer "user_id",                    :null => false
    t.string  "first_name", :default => ""
    t.string  "last_name",  :default => ""
    t.string  "gender"
    t.date    "birthdate"
    t.string  "occupation", :default => ""
    t.string  "city",       :default => ""
    t.string  "state",      :default => ""
    t.string  "zip_code",   :default => ""
  end

  create_table "users", :force => true do |t|
    t.string   "screen_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authorization_token"
  end

end
