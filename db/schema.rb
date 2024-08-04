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

ActiveRecord::Schema[7.1].define(version: 2024_08_01_092820) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "fullname"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "analytics", force: :cascade do |t|
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_bookmarks_on_product_id"
    t.index ["purchaser_id"], name: "index_bookmarks_on_purchaser_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.index ["purchaser_id"], name: "index_cart_items_on_purchaser_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "categories_vendors", id: false, force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id", "vendor_id"], name: "index_categories_vendors_on_category_id_and_vendor_id"
    t.index ["vendor_id", "category_id"], name: "index_categories_vendors_on_vendor_id_and_category_id"
  end

  create_table "cms_pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "vendor_id", null: false
    t.text "options", default: [], array: true
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_notifications_on_product_id"
    t.index ["vendor_id"], name: "index_notifications_on_vendor_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "order_vendors", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "vendor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_vendors_on_order_id"
    t.index ["vendor_id"], name: "index_order_vendors_on_vendor_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.string "status", default: "processing"
    t.decimal "total_amount"
    t.string "mpesa_transaction_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchaser_id"], name: "index_orders_on_purchaser_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "category_id", null: false
    t.string "title"
    t.text "description"
    t.text "media"
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity"
    t.string "brand"
    t.string "manufacturer"
    t.decimal "package_weight", precision: 10, scale: 2
    t.decimal "package_length", precision: 10, scale: 2
    t.decimal "package_width", precision: 10, scale: 2
    t.decimal "package_height", precision: 10, scale: 2
    t.boolean "flagged", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["description"], name: "index_products_on_description", opclass: :gin_trgm_ops, using: :gin
    t.index ["title"], name: "index_products_on_title", opclass: :gin_trgm_ops, using: :gin
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
    t.string "fullname"
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.string "phone_number"
    t.string "location"
    t.boolean "blocked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_purchasers_on_email"
    t.index ["username"], name: "index_purchasers_on_username"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "purchaser_id", null: false
    t.integer "rating", limit: 2, null: false
    t.text "review"
    t.text "reply"
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
    t.string "fullname"
    t.text "description"
    t.string "phone_number"
    t.string "location"
    t.decimal "total_revenue"
    t.integer "total_orders"
    t.jsonb "customer_demographics"
    t.jsonb "analytics"
    t.string "business_registration_number"
    t.string "enterprise_name"
    t.string "email"
    t.boolean "blocked", default: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookmarks", "products"
  add_foreign_key "bookmarks", "purchasers"
  add_foreign_key "cart_items", "products"
  add_foreign_key "cart_items", "purchasers"
  add_foreign_key "notifications", "products"
  add_foreign_key "notifications", "vendors"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "order_vendors", "orders"
  add_foreign_key "order_vendors", "vendors"
  add_foreign_key "orders", "purchasers"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "vendors"
  add_foreign_key "promotions", "vendors"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "purchasers"
  add_foreign_key "shipments", "orders"
end
