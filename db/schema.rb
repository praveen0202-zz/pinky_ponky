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

ActiveRecord::Schema.define(:version => 20141224170656) do

  create_table "customer_bills", :force => true do |t|
    t.integer  "customer_id",                                       :null => false
    t.integer  "product_id",                                        :null => false
    t.integer  "bill_number",                                       :null => false
    t.date     "bill_date",                                         :null => false
    t.integer  "product_price_id",                                  :null => false
    t.decimal  "quantity",            :precision => 8, :scale => 2, :null => false
    t.decimal  "bill_amount",         :precision => 8, :scale => 2, :null => false
    t.string   "status",                                            :null => false
    t.integer  "lock_version"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "customer_vehicle_id",                               :null => false
    t.integer  "invoice_id"
    t.string   "indent_number"
  end

  create_table "customer_vehicles", :force => true do |t|
    t.integer  "customer_id",     :null => false
    t.integer  "vehicle_type_id", :null => false
    t.string   "vehicle_number",  :null => false
    t.integer  "lock_version"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.integer  "phone_number"
    t.integer  "lock_version"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "active",       :default => true
  end

  create_table "invoice_payments", :force => true do |t|
    t.integer  "invoice_id",                                            :null => false
    t.integer  "customer_id",                                           :null => false
    t.decimal  "amount_paid",            :precision => 10, :scale => 2, :null => false
    t.date     "paid_date",                                             :null => false
    t.integer  "lock_version"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "invoice_payment_number"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "customer_id",                                                                       :null => false
    t.date     "invoice_date",                                                                      :null => false
    t.decimal  "invoice_amount",                  :precision => 10, :scale => 2,                    :null => false
    t.integer  "lock_version"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.string   "invoice_number"
    t.decimal  "previous_invoice_amount",         :precision => 10, :scale => 2
    t.decimal  "previous_invoice_paid_amount",    :precision => 10, :scale => 2
    t.boolean  "invoice_closed",                                                 :default => false
    t.decimal  "total_invoice_amount",            :precision => 10, :scale => 2
    t.decimal  "previous_invoice_pending_amount", :precision => 10, :scale => 2
    t.string   "status",                                                                            :null => false
  end

  create_table "product_prices", :force => true do |t|
    t.integer  "product_id",                                   :null => false
    t.decimal  "rate",           :precision => 8, :scale => 2, :null => false
    t.date     "effective_from",                               :null => false
    t.date     "effective_to"
    t.integer  "lock_version"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "product_name"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "unique_identifiers", :force => true do |t|
    t.string   "identifier",   :null => false
    t.string   "type"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "vehicle_types", :force => true do |t|
    t.string   "vehicle_name", :null => false
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
