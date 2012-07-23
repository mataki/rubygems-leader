# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120723100746) do

  create_table "scheduled_updates", :force => true do |t|
    t.integer  "profile_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "handle"
    t.integer  "profile_id"
    t.integer  "total_downloads"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "rank"
  end

  add_index "users", ["rank"], :name => "index_users_on_rank"
  add_index "users", ["total_downloads"], :name => "index_users_on_total_downloads"

end
