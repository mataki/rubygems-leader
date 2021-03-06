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

ActiveRecord::Schema.define(:version => 20120731125150) do

  create_table "claim_identity_keys", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "github_user_id"
  end

  add_index "claim_identity_keys", ["user_id"], :name => "index_claim_identity_keys_on_user_id"

  create_table "github_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "email"
    t.string   "login"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "rank"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["team_id"], :name => "index_memberships_on_team_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "rank_histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rank"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rank_histories", ["user_id"], :name => "index_rank_histories_on_user_id"

  create_table "scheduled_updates", :force => true do |t|
    t.integer  "profile_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "url"
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
    t.string   "coderwall_name"
  end

  add_index "users", ["rank"], :name => "index_users_on_rank"
  add_index "users", ["total_downloads"], :name => "index_users_on_total_downloads"

end
