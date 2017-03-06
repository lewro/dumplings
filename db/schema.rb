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

ActiveRecord::Schema.define(version: 20170306093515) do

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

  add_index "client_order_products", ["order_id"], name: "index_client_order_products_on_order_id", using: :btree
  add_index "client_order_products", ["product_id"], name: "index_client_order_products_on_product_id", using: :btree
  add_index "client_order_products", ["user_id"], name: "index_client_order_products_on_user_id", using: :btree

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
    t.boolean  "stock_deducted"
  end

  add_index "client_orders", ["client_id"], name: "index_client_orders_on_client_id", using: :btree
  add_index "client_orders", ["offer_id"], name: "index_client_orders_on_offer_id", using: :btree
  add_index "client_orders", ["user_id"], name: "index_client_orders_on_user_id", using: :btree

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
    t.string   "email",               limit: 255
  end

  add_index "companies", ["sales_id"], name: "index_companies_on_sales_id", using: :btree
  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

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

  add_index "delivery_addresses", ["company_id"], name: "index_delivery_addresses_on_company_id", using: :btree
  add_index "delivery_addresses", ["user_id"], name: "index_delivery_addresses_on_user_id", using: :btree

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

  add_index "delivery_note_products", ["delivery_note_id"], name: "index_delivery_note_products_on_delivery_note_id", using: :btree
  add_index "delivery_note_products", ["product_id"], name: "index_delivery_note_products_on_product_id", using: :btree
  add_index "delivery_note_products", ["user_id"], name: "index_delivery_note_products_on_user_id", using: :btree

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
    t.boolean  "stock_deducted"
  end

  add_index "delivery_notes", ["client_id"], name: "index_delivery_notes_on_client_id", using: :btree
  add_index "delivery_notes", ["order_id"], name: "index_delivery_notes_on_order_id", using: :btree
  add_index "delivery_notes", ["user_id"], name: "index_delivery_notes_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,     null: false
    t.integer  "client_id",  limit: 4,     null: false
    t.text     "note",       limit: 65535
    t.date     "date"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["client_id"], name: "index_events_on_client_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

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

  add_index "file_uploads", ["model_id"], name: "index_file_uploads_on_model_id", using: :btree
  add_index "file_uploads", ["user_id"], name: "index_file_uploads_on_user_id", using: :btree

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

  add_index "invoice_products", ["invoice_id"], name: "index_invoice_products_on_invoice_id", using: :btree
  add_index "invoice_products", ["product_id"], name: "index_invoice_products_on_product_id", using: :btree
  add_index "invoice_products", ["user_id"], name: "index_invoice_products_on_user_id", using: :btree

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
    t.boolean  "stock_deducted"
    t.decimal  "sum_with_tax",                      precision: 16, scale: 2
    t.integer  "linked_proforma_id",  limit: 4
  end

  add_index "invoices", ["client_id"], name: "index_invoices_on_client_id", using: :btree
  add_index "invoices", ["linked_proforma_id"], name: "index_invoices_on_linked_proforma_id", using: :btree
  add_index "invoices", ["order_id"], name: "index_invoices_on_order_id", using: :btree
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

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

  add_index "offer_products", ["offer_id"], name: "index_offer_products_on_offer_id", using: :btree
  add_index "offer_products", ["product_id"], name: "index_offer_products_on_product_id", using: :btree
  add_index "offer_products", ["user_id"], name: "index_offer_products_on_user_id", using: :btree

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

  add_index "offers", ["client_id"], name: "index_offers_on_client_id", using: :btree
  add_index "offers", ["user_id"], name: "index_offers_on_user_id", using: :btree

  create_table "payment_conditions", force: :cascade do |t|
    t.string   "name",       limit: 255,   null: false
    t.integer  "user_id",    limit: 4,     null: false
    t.text     "text",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_conditions", ["user_id"], name: "index_payment_conditions_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "invoice_id", limit: 4
    t.integer  "user_id",    limit: 4,                          null: false
    t.decimal  "sum",                  precision: 16, scale: 2
    t.datetime "paid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["invoice_id"], name: "index_payments_on_invoice_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "product_supplies", force: :cascade do |t|
    t.integer  "product_id",    limit: 4, null: false
    t.integer  "supply_id",     limit: 4, null: false
    t.integer  "user_id",       limit: 4, null: false
    t.integer  "packages_size", limit: 4
    t.integer  "unit",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_supplies", ["product_id"], name: "index_product_supplies_on_product_id", using: :btree
  add_index "product_supplies", ["supply_id"], name: "index_product_supplies_on_supply_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",         limit: 255,   null: false
    t.integer  "user_id",      limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note",         limit: 65535
    t.string   "product_code", limit: 255
    t.integer  "tax_group_id", limit: 4
    t.integer  "unit",         limit: 4
  end

  add_index "products", ["tax_group_id"], name: "index_products_on_tax_group_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

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

  add_index "retail_products", ["product_id"], name: "index_retail_products_on_product_id", using: :btree
  add_index "retail_products", ["retail_id"], name: "index_retail_products_on_retail_id", using: :btree
  add_index "retail_products", ["user_id"], name: "index_retail_products_on_user_id", using: :btree

  create_table "retails", force: :cascade do |t|
    t.integer  "user_id",        limit: 4,                              null: false
    t.integer  "payment_type",   limit: 4,                              null: false
    t.integer  "delivery_type",  limit: 4,                              null: false
    t.decimal  "sum",                          precision: 16, scale: 2
    t.decimal  "transport_cost",               precision: 10
    t.text     "note",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "stock_deducted"
  end

  add_index "retails", ["user_id"], name: "index_retails_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.integer  "user_id",          limit: 4,   null: false
    t.integer  "id_format",        limit: 4
    t.string   "currency",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_tax"
    t.integer  "expiration_alert", limit: 4
  end

  add_index "settings", ["user_id"], name: "index_settings_on_user_id", using: :btree

  create_table "stock_product_reductions", force: :cascade do |t|
    t.integer  "stock_product_id",  limit: 4,   null: false
    t.string   "actual_model_name", limit: 255
    t.integer  "actual_model_id",   limit: 4
    t.integer  "user_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "packages_size",     limit: 4
  end

  create_table "stock_products", force: :cascade do |t|
    t.integer  "supply_id",       limit: 4,                                           null: false
    t.integer  "order_id",        limit: 4,                                           null: false
    t.integer  "packages_size",   limit: 4
    t.decimal  "unit_price",                precision: 16, scale: 10
    t.integer  "unit",            limit: 4
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "gone",                                                default: false
  end

  add_index "stock_products", ["order_id"], name: "index_stock_products_on_order_id", using: :btree
  add_index "stock_products", ["supply_id"], name: "index_stock_products_on_supply_id", using: :btree

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

  add_index "supplier_order_products", ["order_id"], name: "index_supplier_order_products_on_order_id", using: :btree
  add_index "supplier_order_products", ["supply_id"], name: "index_supplier_order_products_on_supply_id", using: :btree
  add_index "supplier_order_products", ["user_id"], name: "index_supplier_order_products_on_user_id", using: :btree

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

  add_index "supplier_orders", ["supplier_id"], name: "index_supplier_orders_on_supplier_id", using: :btree
  add_index "supplier_orders", ["user_id"], name: "index_supplier_orders_on_user_id", using: :btree

  create_table "supplies", force: :cascade do |t|
    t.string   "name",         limit: 255,   null: false
    t.integer  "user_id",      limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note",         limit: 65535
    t.string   "product_code", limit: 255
  end

  add_index "supplies", ["user_id"], name: "index_supplies_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.text     "message",          limit: 65535
    t.string   "condition_object", limit: 255
    t.string   "operator",         limit: 255
    t.integer  "condition_value",  limit: 4
    t.integer  "condition_unit",   limit: 4
    t.integer  "frequency_value",  limit: 4
    t.integer  "status",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
  end

  create_table "tax_groups", force: :cascade do |t|
    t.integer  "tax",        limit: 4,     null: false
    t.string   "user_id",    limit: 255,   null: false
    t.text     "note",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tax_groups", ["user_id"], name: "index_tax_groups_on_user_id", using: :btree

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
    t.integer  "category",               limit: 4,     default: 0,  null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.text     "note",                   limit: 65535
    t.integer  "admin_id",               limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
