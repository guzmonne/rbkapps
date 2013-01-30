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

ActiveRecord::Schema.define(:version => 20130130195823) do

  create_table "purchase_request_lines", :force => true do |t|
    t.integer  "purchase_request_id"
    t.string   "description"
    t.integer  "quantity"
    t.string   "unit"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "purchase_requests", :force => true do |t|
    t.integer  "user_id"
    t.string   "sector"
    t.date     "deliver_at"
    t.string   "use"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "state"
    t.integer  "team_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "supervisor_id"
    t.integer  "director_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "teams", ["supervisor_id"], :name => "index_teams_on_supervisor_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "position"
    t.string   "phone"
    t.string   "cellphone"
    t.integer  "location_id"
    t.integer  "team_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
