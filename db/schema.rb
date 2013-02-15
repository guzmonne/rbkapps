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

ActiveRecord::Schema.define(:version => 20130215142917) do

  create_table "deliveries", :force => true do |t|
    t.string   "courier"
    t.string   "dispatch"
    t.integer  "guide"
    t.integer  "guide2"
    t.integer  "guide3"
    t.decimal  "cargo_cost",            :precision => 8, :scale => 2
    t.decimal  "cargo_cost2",           :precision => 8, :scale => 2
    t.decimal  "cargo_cost3",           :precision => 8, :scale => 2
    t.decimal  "dispatch_cost",         :precision => 8, :scale => 2
    t.decimal  "dua_cost",              :precision => 8, :scale => 2
    t.string   "supplier"
    t.string   "origin"
    t.date     "origin_date"
    t.date     "arrival_date"
    t.date     "delivery_date"
    t.text     "status"
    t.date     "invoice_delivery_date"
    t.date     "doc_courier_date"
    t.integer  "invoice_number"
    t.decimal  "fob_total_cost",        :precision => 8, :scale => 2
    t.decimal  "total_units_cost",      :precision => 8, :scale => 2
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "deliveries", ["guide"], :name => "index_deliveries_on_guide"

  create_table "items", :force => true do |t|
    t.string   "brand"
    t.string   "season"
    t.string   "entry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "code"
  end

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
