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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170125121541) do

  create_table "client_order_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                          null: false
    t.integer  "order_id",          limit: 4,                          null: false
    t.integer  "user_id",           limit: 4,                          null: false
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "package_price",               precision: 16, scale: 2
    t.integer  "unit",              limit: 4
    t.datetime "expiration_date"
  end

  create_table "client_orders", force: :cascade do |t|
    t.integer  "client_id",          limit: 4,                              null: false
    t.integer  "user_id",            limit: 4,                              null: false
    t.datetime "distribution"
    t.decimal  "sum",                              precision: 16, scale: 2
    t.text     "note",               limit: 65535
    t.integer  "status",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "offer_id",           limit: 4
    t.string   "reference_id",       limit: 255
    t.datetime "order_confirmation"
    t.integer  "payment_condition",  limit: 4
    t.text     "delivery_terms",     limit: 65535
    t.datetime "expected_delivery"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",                limit: 255,   null: false
    t.string   "registration_number", limit: 255,   null: false
    t.string   "vat_number",          limit: 255
    t.string   "street",              limit: 255
    t.string   "street_number",       limit: 255
    t.string   "city",                limit: 255
    t.string   "zip_code",            limit: 255
    t.string   "country",             limit: 255
    t.integer  "status",              limit: 4
    t.string   "category",            limit: 255
    t.text     "note",                limit: 65535
    t.integer  "sales_id",            limit: 4
    t.integer  "user_id",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_person",      limit: 255
    t.string   "bank",                limit: 255
    t.string   "account_number",      limit: 255
    t.string   "swift_code",          limit: 255
    t.string   "iban_code",           limit: 255
    t.string   "legal",               limit: 255
    t.boolean  "use_tax"
  end

  create_table "delivery_addresses", force: :cascade do |t|
    t.integer  "company_id",    limit: 4,   null: false
    t.string   "street",        limit: 255, null: false
    t.string   "street_number", limit: 255
    t.string   "city",          limit: 255, null: false
    t.string   "zip_code",      limit: 255
    t.string   "country",       limit: 255
    t.string   "user_id",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_note_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                          null: false
    t.integer  "delivery_note_id",  limit: 4,                          null: false
    t.integer  "user_id",           limit: 4,                          null: false
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.decimal  "package_price",               precision: 16, scale: 2
    t.integer  "unit",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expiration_date"
  end

  create_table "delivery_notes", force: :cascade do |t|
    t.integer  "client_id",            limit: 4,                              null: false
    t.integer  "user_id",              limit: 4,                              null: false
    t.integer  "order_id",             limit: 4
    t.string   "reference_id",         limit: 255
    t.decimal  "sum",                                precision: 16, scale: 2
    t.text     "note",                 limit: 65535
    t.integer  "payment_condition",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "issue_date"
    t.integer  "delivery_address_id",  limit: 4
    t.string   "contact_person_name",  limit: 255
    t.string   "contact_person_phone", limit: 255
  end

  create_table "events", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,     null: false
    t.integer  "client_id",  limit: 4,     null: false
    t.text     "note",       limit: 65535
    t.date     "date"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_uploads", force: :cascade do |t|
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "model_id",            limit: 4
    t.integer  "upload_file_size",    limit: 4
    t.string   "file_type",           limit: 255
    t.string   "model",               limit: 255
    t.integer  "user_id",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                          null: false
    t.integer  "invoice_id",        limit: 4,                          null: false
    t.integer  "user_id",           limit: 4,                          null: false
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.decimal  "package_price",               precision: 16, scale: 2
    t.integer  "unit",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expiration_date"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "client_id",           limit: 4,                                              null: false
    t.integer  "user_id",             limit: 4,                                              null: false
    t.decimal  "sum",                               precision: 16, scale: 2
    t.datetime "due_date"
    t.datetime "paid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id",            limit: 4
    t.text     "note",                limit: 65535
    t.string   "reference_id",        limit: 255
    t.integer  "payment_condition",   limit: 4
    t.text     "delivery_terms",      limit: 65535
    t.boolean  "proforma",                                                   default: false
    t.datetime "issue_date"
    t.datetime "taxable_supply_date"
  end

  create_table "offer_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                          null: false
    t.integer  "offer_id",          limit: 4,                          null: false
    t.integer  "user_id",           limit: 4,                          null: false
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.decimal  "package_price",               precision: 16, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit",              limit: 4
    t.datetime "expiration_date"
  end

  create_table "offers", force: :cascade do |t|
    t.integer  "client_id",         limit: 4,                              null: false
    t.integer  "user_id",           limit: 4,                              null: false
    t.decimal  "sum",                             precision: 16, scale: 2
    t.text     "note",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference_id",      limit: 255
    t.datetime "issue_date"
    t.integer  "payment_condition", limit: 4
    t.text     "delivery_terms",    limit: 65535
  end

  create_table "payment_conditions", force: :cascade do |t|
    t.string   "name",       limit: 255,   null: false
    t.integer  "user_id",    limit: 4,     null: false
    t.text     "text",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "invoice_id", limit: 4,                          null: false
    t.integer  "user_id",    limit: 4,                          null: false
    t.decimal  "sum",                  precision: 16, scale: 2
    t.datetime "paid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_supplies", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                          null: false
    t.integer  "supply_id",         limit: 4,                          null: false
    t.integer  "user_id",           limit: 4,                          null: false
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.decimal  "package_price",               precision: 16, scale: 2
    t.integer  "unit",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",         limit: 255,   null: false
    t.integer  "user_id",      limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note",         limit: 65535
    t.string   "product_code", limit: 255
    t.integer  "tax_group_id", limit: 4
  end

  create_table "retail_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                            null: false
    t.integer  "retail_id",         limit: 4,                            null: false
    t.integer  "user_id",           limit: 4,                            null: false
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.decimal  "package_price",                 precision: 16, scale: 2
    t.integer  "unit",              limit: 4
    t.string   "product_code",      limit: 255
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retails", force: :cascade do |t|
    t.integer  "user_id",        limit: 4,                              null: false
    t.integer  "payment_type",   limit: 4,                              null: false
    t.integer  "delivery_type",  limit: 4,                              null: false
    t.decimal  "sum",                          precision: 16, scale: 2
    t.decimal  "transport_cost",               precision: 10
    t.text     "note",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,   null: false
    t.integer  "id_format",  limit: 4
    t.string   "currency",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_tax"
  end

  create_table "stock_group_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                          null: false
    t.integer  "stock_group_id",    limit: 4,                          null: false
    t.integer  "user_id",           limit: 4,                          null: false
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.decimal  "package_price",               precision: 16, scale: 2
    t.integer  "unit",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expiration_date"
  end

  create_table "stock_groups", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "user_id",    limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,                                        null: false
    t.integer  "packages_quantity", limit: 4,                                        null: false
    t.integer  "packages_size",     limit: 4,                                        null: false
    t.decimal  "package_price",               precision: 16, scale: 2,               null: false
    t.integer  "unit",              limit: 4,                                        null: false
    t.integer  "progress",          limit: 4,                          default: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplier_order_products", force: :cascade do |t|
    t.integer  "supply_id",         limit: 4,                          null: false
    t.integer  "order_id",          limit: 4,                          null: false
    t.integer  "user_id",           limit: 4,                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "packages_quantity", limit: 4
    t.integer  "packages_size",     limit: 4
    t.decimal  "package_price",               precision: 16, scale: 2
    t.integer  "unit",              limit: 4
    t.datetime "expiration_date"
  end

  create_table "supplier_orders", force: :cascade do |t|
    t.integer  "supplier_id",       limit: 4,                              null: false
    t.integer  "user_id",           limit: 4,                              null: false
    t.string   "contact_person",    limit: 255
    t.datetime "expected_delivery"
    t.datetime "delivery"
    t.decimal  "sum",                             precision: 16, scale: 2
    t.text     "note",              limit: 65535
    t.integer  "status",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplies", force: :cascade do |t|
    t.string   "name",         limit: 255,   null: false
    t.integer  "user_id",      limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note",         limit: 65535
    t.string   "product_code", limit: 255
  end

  create_table "tax_groups", force: :cascade do |t|
    t.integer  "tax",        limit: 4,     null: false
    t.string   "user_id",    limit: 255,   null: false
    t.text     "note",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "category",               limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.text     "note",                   limit: 65535
    t.integer  "admin_id",               limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
