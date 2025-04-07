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

ActiveRecord::Schema[8.0].define(version: 2025_04_07_071100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "abouts", force: :cascade do |t|
    t.text "description"
    t.text "mission"
    t.text "vision"
    t.jsonb "values", default: []
    t.text "why_choose_us"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ad_searches", force: :cascade do |t|
    t.string "search_term", null: false
    t.bigint "purchaser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchaser_id"], name: "index_ad_searches_on_purchaser_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "fullname"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ads", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "category_id", null: false
    t.bigint "subcategory_id", null: false
    t.string "title"
    t.text "description"
    t.text "media"
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity"
    t.string "brand"
    t.string "manufacturer"
    t.decimal "item_weight", precision: 10, scale: 2
    t.string "weight_unit", default: "Grams"
    t.decimal "item_length", precision: 10, scale: 2
    t.decimal "item_width", precision: 10, scale: 2
    t.decimal "item_height", precision: 10, scale: 2
    t.boolean "flagged", default: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["category_id"], name: "index_ads_on_category_id"
    t.index ["description"], name: "index_ads_on_description", opclass: :gin_trgm_ops, using: :gin
    t.index ["subcategory_id"], name: "index_ads_on_subcategory_id"
    t.index ["title"], name: "index_ads_on_title", opclass: :gin_trgm_ops, using: :gin
    t.index ["vendor_id"], name: "index_ads_on_vendor_id"
  end

  create_table "analytics", force: :cascade do |t|
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", force: :cascade do |t|
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buy_for_me_order_cart_items", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.bigint "ad_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_buy_for_me_order_cart_items_on_ad_id"
    t.index ["purchaser_id"], name: "index_buy_for_me_order_cart_items_on_purchaser_id"
  end

  create_table "buy_for_me_order_items", force: :cascade do |t|
    t.bigint "buy_for_me_order_id", null: false
    t.bigint "ad_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["ad_id"], name: "index_buy_for_me_order_items_on_ad_id"
    t.index ["buy_for_me_order_id"], name: "index_buy_for_me_order_items_on_buy_for_me_order_id"
  end

  create_table "buy_for_me_order_vendors", force: :cascade do |t|
    t.bigint "buy_for_me_order_id", null: false
    t.bigint "vendor_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["buy_for_me_order_id"], name: "index_buy_for_me_order_vendors_on_buy_for_me_order_id"
    t.index ["vendor_id"], name: "index_buy_for_me_order_vendors_on_vendor_id"
  end

  create_table "buy_for_me_orders", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2
    t.decimal "processing_fee", precision: 10, scale: 2
    t.decimal "delivery_fee", precision: 10, scale: 2
    t.string "mpesa_transaction_code"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["purchaser_id"], name: "index_buy_for_me_orders_on_purchaser_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.bigint "ad_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_cart_items_on_ad_id"
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

  create_table "click_events", force: :cascade do |t|
    t.bigint "purchaser_id"
    t.bigint "ad_id"
    t.string "event_type", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_click_events_on_ad_id"
    t.index ["purchaser_id"], name: "index_click_events_on_purchaser_id"
  end

  create_table "cms_pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "purchaser_id"
    t.bigint "vendor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_conversations_on_admin_id"
    t.index ["purchaser_id"], name: "index_conversations_on_purchaser_id"
    t.index ["vendor_id"], name: "index_conversations_on_vendor_id"
  end

  create_table "counties", force: :cascade do |t|
    t.string "name", null: false
    t.string "capital", null: false
    t.integer "county_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_code"], name: "index_counties_on_county_code", unique: true
    t.index ["name"], name: "index_counties_on_name", unique: true
  end

  create_table "educations", force: :cascade do |t|
    t.string "level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_educations_on_level", unique: true
  end

  create_table "employments", force: :cascade do |t|
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_employments_on_status", unique: true
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incomes", force: :cascade do |t|
    t.string "range", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["range"], name: "index_incomes_on_range", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "sender_id"
    t.string "sender_type"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.integer "order_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "ad_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["ad_id"], name: "index_order_items_on_ad_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_vendors", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "vendor_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["order_id"], name: "index_order_vendors_on_order_id"
    t.index ["vendor_id"], name: "index_order_vendors_on_vendor_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.string "status", default: "Processing"
    t.decimal "total_amount", precision: 10, scale: 2
    t.decimal "processing_fee", precision: 10, scale: 2
    t.decimal "delivery_fee", precision: 10, scale: 2
    t.string "mpesa_transaction_code"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["purchaser_id"], name: "index_orders_on_purchaser_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "transaction_type"
    t.string "trans_id"
    t.string "trans_time"
    t.decimal "trans_amount"
    t.string "business_short_code"
    t.string "bill_ref_number"
    t.string "invoice_number"
    t.string "org_account_balance"
    t.string "third_party_trans_id"
    t.string "msisdn"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promotions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "discount_percentage"
    t.string "coupon_code"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchasers", force: :cascade do |t|
    t.string "fullname"
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.string "phone_number", limit: 10
    t.datetime "birthdate"
    t.string "zipcode"
    t.string "city"
    t.string "gender", default: "Male"
    t.string "location"
    t.string "profile_picture"
    t.boolean "blocked", default: false
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.bigint "income_id"
    t.bigint "employment_id"
    t.bigint "education_id"
    t.bigint "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_purchasers_on_county_id"
    t.index ["education_id"], name: "index_purchasers_on_education_id"
    t.index ["email"], name: "index_purchasers_on_email"
    t.index ["employment_id"], name: "index_purchasers_on_employment_id"
    t.index ["income_id"], name: "index_purchasers_on_income_id"
    t.index ["sector_id"], name: "index_purchasers_on_sector_id"
    t.index ["sub_county_id"], name: "index_purchasers_on_sub_county_id"
    t.index ["username"], name: "index_purchasers_on_username"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "ad_id", null: false
    t.bigint "purchaser_id", null: false
    t.integer "rating", limit: 2, null: false
    t.text "review"
    t.text "reply"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_reviews_on_ad_id"
    t.index ["purchaser_id"], name: "index_reviews_on_purchaser_id"
  end

  create_table "riders", force: :cascade do |t|
    t.string "full_name"
    t.string "phone_number"
    t.date "date_of_birth"
    t.string "email"
    t.string "id_number"
    t.string "driving_license"
    t.string "vehicle_type"
    t.string "license_plate"
    t.string "physical_address"
    t.string "gender", default: "Male"
    t.boolean "blocked", default: false
    t.string "password_digest"
    t.string "kin_full_name"
    t.string "kin_relationship"
    t.string "kin_phone_number"
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_riders_on_county_id"
    t.index ["sub_county_id"], name: "index_riders_on_sub_county_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name", unique: true
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

  create_table "sub_counties", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sub_county_code", null: false
    t.bigint "county_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_sub_counties_on_county_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tier_features", force: :cascade do |t|
    t.bigint "tier_id", null: false
    t.string "feature_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier_id"], name: "index_tier_features_on_tier_id"
  end

  create_table "tier_pricings", force: :cascade do |t|
    t.bigint "tier_id", null: false
    t.integer "duration_months", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier_id"], name: "index_tier_pricings_on_tier_id"
  end

  create_table "tiers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ads_limit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vendor_tiers", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.bigint "tier_id", null: false
    t.integer "duration_months", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier_id"], name: "index_vendor_tiers_on_tier_id"
    t.index ["vendor_id"], name: "index_vendor_tiers_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "fullname"
    t.string "username"
    t.string "description"
    t.string "phone_number", limit: 10
    t.string "location"
    t.string "business_registration_number"
    t.string "enterprise_name"
    t.bigint "county_id", null: false
    t.bigint "sub_county_id", null: false
    t.string "email"
    t.string "profile_picture"
    t.datetime "birthdate"
    t.string "zipcode"
    t.string "city"
    t.string "gender", default: "Male"
    t.boolean "blocked", default: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_vendors_on_county_id"
    t.index ["sub_county_id"], name: "index_vendors_on_sub_county_id"
  end

  create_table "wish_lists", force: :cascade do |t|
    t.bigint "purchaser_id", null: false
    t.bigint "ad_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_wish_lists_on_ad_id"
    t.index ["purchaser_id"], name: "index_wish_lists_on_purchaser_id"
  end

  add_foreign_key "ad_searches", "purchasers"
  add_foreign_key "ads", "categories"
  add_foreign_key "ads", "subcategories"
  add_foreign_key "ads", "vendors"
  add_foreign_key "buy_for_me_order_cart_items", "ads"
  add_foreign_key "buy_for_me_order_cart_items", "purchasers"
  add_foreign_key "buy_for_me_order_items", "ads"
  add_foreign_key "buy_for_me_order_items", "buy_for_me_orders"
  add_foreign_key "buy_for_me_order_vendors", "buy_for_me_orders"
  add_foreign_key "buy_for_me_order_vendors", "vendors"
  add_foreign_key "buy_for_me_orders", "purchasers"
  add_foreign_key "cart_items", "ads"
  add_foreign_key "cart_items", "purchasers"
  add_foreign_key "click_events", "ads"
  add_foreign_key "click_events", "purchasers"
  add_foreign_key "conversations", "admins"
  add_foreign_key "conversations", "purchasers"
  add_foreign_key "conversations", "vendors"
  add_foreign_key "order_items", "ads"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_vendors", "orders"
  add_foreign_key "order_vendors", "vendors"
  add_foreign_key "orders", "purchasers"
  add_foreign_key "purchasers", "counties"
  add_foreign_key "purchasers", "educations"
  add_foreign_key "purchasers", "employments"
  add_foreign_key "purchasers", "incomes"
  add_foreign_key "purchasers", "sectors"
  add_foreign_key "purchasers", "sub_counties"
  add_foreign_key "reviews", "ads"
  add_foreign_key "reviews", "purchasers"
  add_foreign_key "riders", "counties"
  add_foreign_key "riders", "sub_counties"
  add_foreign_key "shipments", "orders"
  add_foreign_key "sub_counties", "counties"
  add_foreign_key "tier_features", "tiers"
  add_foreign_key "tier_pricings", "tiers"
  add_foreign_key "vendor_tiers", "tiers"
  add_foreign_key "vendor_tiers", "vendors"
  add_foreign_key "vendors", "counties"
  add_foreign_key "vendors", "sub_counties"
  add_foreign_key "wish_lists", "ads"
  add_foreign_key "wish_lists", "purchasers"
end
