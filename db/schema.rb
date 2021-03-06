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

ActiveRecord::Schema.define(:version => 20100214214735) do

  create_table "challenges", :force => true do |t|
    t.integer  "mission_id"
    t.integer  "index"
    t.string   "state",      :default => "in_progress"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missions", :force => true do |t|
    t.string   "state"
    t.text     "message"
    t.integer  "ninja_id"
    t.integer  "victim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "progress",   :default => 0
    t.integer  "momentum",   :default => 0
  end

  create_table "ninjas", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
