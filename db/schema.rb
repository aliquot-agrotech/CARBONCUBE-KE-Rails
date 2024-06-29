# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_29_183330) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analytics", force: :cascade do |t|
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cms_pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.datetime "invoice_date"
    t.decimal "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_invoices_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.string "status"
    t.decimal "total_amount"
    t.boolean "is_sent_out"
    t.boolean "is_processing"
    t.boolean "is_delivered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchaser_id"], name: "index_orders_on_purchaser_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "category_id", null: false
    t.string "name"
    t.text "description"
    t.string "image_url"
    t.jsonb "specifications"
    t.text "compatibility"
    t.decimal "price"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["vendor_id"], name: "index_products_on_vendor_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.string "title"
    t.text "description"
    t.decimal "discount_percentage"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vendor_id"], name: "index_promotions_on_vendor_id"
  end

  create_table "purchasers", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "phone_number"
    t.string "location"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "fullname"
    t.index ["email"], name: "index_purchasers_on_email"
    t.index ["username"], name: "index_purchasers_on_username"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "purchaser_id", null: false
    t.integer "rating"
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["purchaser_id"], name: "index_reviews_on_purchaser_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "carrier"
    t.string "tracking_number"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_shipments_on_order_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "contact_info"
    t.string "phone_number"
    t.string "location"
    t.bigint "category_id", null: false
    t.decimal "total_revenue"
    t.integer "total_orders"
    t.jsonb "customer_demographics"
    t.jsonb "analytics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "business_number_registration"
    t.string "enterprise_name"
    t.string "email"
    t.index ["category_id"], name: "index_vendors_on_category_id"
  end

  add_foreign_key "invoices", "orders"
  add_foreign_key "orders", "purchasers"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "vendors"
  add_foreign_key "promotions", "vendors"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "purchasers"
  add_foreign_key "shipments", "orders"
  add_foreign_key "vendors", "categories"
end
