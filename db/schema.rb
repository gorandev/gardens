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

ActiveRecord::Schema.define(:version => 20120904142851) do

  create_table "alerts", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
    t.integer  "country_id"
  end

  add_index "alerts", ["country_id"], :name => "index_alerts_on_country_id"
  add_index "alerts", ["event_id"], :name => "index_alerts_on_event_id"
  add_index "alerts", ["product_type_id"], :name => "index_alerts_on_product_type_id"
  add_index "alerts", ["user_id"], :name => "index_alerts_on_user_id"

  create_table "countries", :force => true do |t|
    t.string   "iso_code"
    t.string   "name"
    t.string   "status"
    t.string   "locale"
    t.string   "decimal_separator"
    t.string   "thousands_separator"
    t.string   "time_zone"
    t.integer  "currency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["currency_id"], :name => "index_countries_on_currency_id"

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "symbol"
    t.integer  "decimal_places"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "item_id"
    t.integer  "precio_viejo"
    t.integer  "precio_nuevo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["item_id"], :name => "index_events_on_item_id"

  create_table "items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "retailer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.integer  "product_type_id"
    t.integer  "imagen_id"
    t.string   "url"
    t.text     "description"
    t.string   "aws_filename"
    t.boolean  "ignored"
  end

  add_index "items", ["product_id"], :name => "index_items_on_product_id"
  add_index "items", ["product_type_id"], :name => "index_items_on_product_type_id"
  add_index "items", ["retailer_id"], :name => "index_items_on_retailer_id"

  create_table "items_property_values", :id => false, :force => true do |t|
    t.integer "item_id"
    t.integer "property_value_id"
  end

  create_table "media_channel_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_channels", :force => true do |t|
    t.string   "name"
    t.integer  "media_channel_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.integer  "retailer_id"
  end

  add_index "media_channels", ["country_id"], :name => "index_media_channels_on_country_id"
  add_index "media_channels", ["media_channel_type_id"], :name => "index_media_channels_on_media_channel_type_id"
  add_index "media_channels", ["retailer_id"], :name => "index_media_channels_on_retailer_id"

  create_table "misspellings", :force => true do |t|
    t.string   "value"
    t.integer  "word_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "misspellings", ["word_id"], :name => "index_misspellings_on_word_id"

  create_table "no_words", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.integer  "item_id"
    t.date     "price_date"
    t.integer  "currency_id"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["currency_id"], :name => "index_prices_on_currency_id"
  add_index "prices", ["item_id"], :name => "index_prices_on_item_id"

  create_table "product_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "status"
    t.integer  "product_type_id"
    t.boolean  "show_on_search"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "imagen_id"
    t.string   "aws_filename"
  end

  add_index "products", ["product_type_id"], :name => "index_products_on_product_type_id"

  create_table "products_property_values", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "property_value_id"
  end

  create_table "properties", :force => true do |t|
    t.string   "name"
    t.integer  "product_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "properties", ["product_type_id"], :name => "index_properties_on_product_type_id"

  create_table "property_values", :force => true do |t|
    t.string   "value"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "word_id"
  end

  add_index "property_values", ["property_id"], :name => "index_property_values_on_property_id"
  add_index "property_values", ["word_id"], :name => "index_property_values_on_word_id"

  create_table "retailers", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
  end

  add_index "retailers", ["country_id"], :name => "index_retailers_on_country_id"

  create_table "rule_types", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
    t.integer  "alert_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rule_type_id"
  end

  add_index "rules", ["alert_id"], :name => "index_rules_on_alert_id"
  add_index "rules", ["rule_type_id"], :name => "index_rules_on_rule_type_id"

  create_table "sales", :force => true do |t|
    t.date     "sale_date"
    t.integer  "price"
    t.string   "origin"
    t.integer  "units_available"
    t.date     "valid_since"
    t.date     "valid_until"
    t.boolean  "bundle"
    t.boolean  "deleted"
    t.integer  "media_channel_id"
    t.integer  "retailer_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page"
    t.integer  "currency_id"
    t.integer  "imagen_id"
    t.string   "aws_filename"
  end

  add_index "sales", ["currency_id"], :name => "index_sales_on_currency_id"
  add_index "sales", ["media_channel_id"], :name => "index_sales_on_media_channel_id"
  add_index "sales", ["product_id"], :name => "index_sales_on_product_id"
  add_index "sales", ["retailer_id"], :name => "index_sales_on_retailer_id"

  create_table "saved_reports", :force => true do |t|
    t.text     "querystring"
    t.integer  "orden"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.integer  "product_type_id"
  end

  add_index "saved_reports", ["product_type_id"], :name => "index_saved_reports_on_product_type_id"
  add_index "saved_reports", ["user_id"], :name => "index_saved_reports_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "product_type_id"
    t.integer  "country_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "subscriptions", ["country_id"], :name => "index_subscriptions_on_country_id"
  add_index "subscriptions", ["product_type_id"], :name => "index_subscriptions_on_product_type_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.boolean  "administrator"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "words", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
