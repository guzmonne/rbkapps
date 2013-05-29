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

ActiveRecord::Schema.define(:version => 20130529134141) do

  create_table "categories", :force => true do |t|
    t.string   "category1"
    t.string   "category2"
    t.string   "category3"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deliveries", :force => true do |t|
    t.string   "courier"
    t.string   "dispatch"
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
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "user_id"
    t.string   "guide"
    t.string   "guide2"
    t.string   "guide3"
    t.decimal  "exchange_rate",         :precision => 8, :scale => 2
  end

  create_table "form_helpers", :force => true do |t|
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "column"
  end

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoices", :force => true do |t|
    t.string   "invoice_number"
    t.decimal  "fob_total_cost", :precision => 8, :scale => 2
    t.integer  "total_units"
    t.integer  "delivery_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "user_id"
  end

  create_table "items", :force => true do |t|
    t.string   "brand"
    t.string   "season"
    t.string   "entry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "code"
    t.integer  "user_id"
  end

  create_table "notes", :force => true do |t|
    t.string   "content",       :limit => 500
    t.integer  "user_id"
    t.string   "table_name"
    t.integer  "table_name_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "purchase_orders", :force => true do |t|
    t.integer  "quotation_id"
    t.text     "observations"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
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
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "state"
    t.text     "detail"
    t.integer  "approver"
    t.string   "cost_center"
    t.integer  "authorizer_id"
    t.date     "should_arrive_at"
    t.date     "closed_at"
  end

  create_table "quotations", :force => true do |t|
    t.integer  "supplier_id"
    t.string   "method_of_payment"
    t.text     "detail"
    t.decimal  "total_net",           :precision => 8, :scale => 2
    t.decimal  "iva",                 :precision => 8, :scale => 2
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "purchase_request_id"
    t.boolean  "selected"
  end

  create_table "service_requests", :force => true do |t|
    t.string   "status"
    t.string   "priority"
    t.text     "solution"
    t.date     "closed_at"
    t.integer  "category_id"
    t.string   "title"
    t.text     "description"
    t.integer  "asigned_to_id"
    t.string   "location"
    t.integer  "creator_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "modified_by"
  end

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "contact"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "method_of_payment"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "entry"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "supervisor_id"
    t.integer  "director_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "cost_center"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "position"
    t.string   "phone"
    t.string   "cellphone"
    t.integer  "team_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.boolean  "comex"
    t.boolean  "compras"
    t.boolean  "director"
    t.boolean  "maintenance"
    t.string   "location"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
