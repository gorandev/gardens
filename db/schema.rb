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

ActiveRecord::Schema.define(:version => 20110506175913) do

  create_table "atributos", :force => true do |t|
    t.string   "descripcion"
    t.integer  "tipo_producto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "atributos", ["tipo_producto_id"], :name => "index_atributos_on_tipo_producto_id"

  create_table "attributes", :force => true do |t|
    t.string   "descripcion"
    t.integer  "tipo_producto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attributes", ["tipo_producto_id"], :name => "index_attributes_on_tipo_producto_id"

  create_table "tipo_productos", :force => true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "valor_atributos", :force => true do |t|
    t.string   "descripcion"
    t.integer  "atributo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "valor_atributos", ["atributo_id"], :name => "index_valor_atributos_on_atributo_id"

end
