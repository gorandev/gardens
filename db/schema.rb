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

ActiveRecord::Schema.define(:version => 20110607211119) do

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

  create_table "items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "retailer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.integer  "product_type_id"
  end

  add_index "items", ["product_id"], :name => "index_items_on_product_id"
  add_index "items", ["product_type_id"], :name => "index_items_on_product_type_id"
  add_index "items", ["retailer_id"], :name => "index_items_on_retailer_id"

  create_table "items_property_values", :id => false, :force => true do |t|
    t.integer "item_id"
    t.integer "property_value_id"
  end

  create_table "prices", :force => true do |t|
    t.integer  "item_id"
    t.datetime "price_date"
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
  end

  add_index "properties", ["product_type_id"], :name => "index_properties_on_product_type_id"

  create_table "property_values", :force => true do |t|
    t.string   "value"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_values", ["property_id"], :name => "index_property_values_on_property_id"

  create_table "retailers", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retailers", ["country_id"], :name => "index_retailers_on_country_id"

end
