# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Country.create(
  :iso_code => "AR", :name => "Argentina", :status => "active", :locale => "es_AR", :time_zone => "GMT-03:00", 
  :currency => Currency.create( :name => "ARS", :symbol => "$" )
  )

Country.create(
  :iso_code => "CL", :name => "Chile", :status => "active", :locale => "es_CL", :time_zone => "GMT-03:00", 
  :currency => Currency.create( :name => "CLP", :symbol => "$" )
  )  
  
ProductType.create([{:name => "computadoras"}, {:name => "televisores"}])

ProductType.find_by_name("computadoras").properties.create([
  {:name => "memoria"}, {:name => "HDD"}, {:name => "marca"}
])

ProductType.find_by_name("televisores").properties.create([
  {:name => "pantalla_size"}, {:name => "marca"}
])

ProductType.find_by_name("computadoras").properties.find_by_name("memoria").property_values.create([
  {:value => "1 Gb"}, {:value => "2 Gb"}, {:value => "4 Gb"}
])

ProductType.find_by_name("computadoras").properties.find_by_name("HDD").property_values.create([
  {:value => "200 Gb"}, {:value => "350 Gb"}, {:value => "500 Gb"}
])

ProductType.find_by_name("computadoras").properties.find_by_name("marca").property_values.create([
  {:value => "Asus"}, {:value => "Apple"}, {:value => "Toshiba"}
])

ProductType.find_by_name("televisores").properties.find_by_name("pantalla_size").property_values.create([
  {:value => "14''"}, {:value => "21''"}, {:value => "34''"}
])

ProductType.find_by_name("televisores").properties.find_by_name("marca").property_values.create([
  {:value => "Sony"}, {:value => "Philips"}, {:value => "LG Electronics"}
])

Product.create(
  :product_type_id => ProductType.find_by_name("computadoras"), 
  :status => "active", 
  :show_on_search => true,
  :property_values => [
    ProductType.find_by_name("computadoras").properties.find_by_name("memoria").property_values.find_by_value("1 Gb"),
    ProductType.find_by_name("computadoras").properties.find_by_name("HDD").property_values.find_by_value("350 Gb"),
    ProductType.find_by_name("computadoras").properties.find_by_name("marca").property_values.find_by_value("Toshiba")
  ]
)

Product.create(
  :product_type_id => ProductType.find_by_name("computadoras"),
  :status => "active",
  :show_on_search => true,
  :property_values => [
    ProductType.find_by_name("computadoras").properties.find_by_name("memoria").property_values.find_by_value("4 Gb"),
    ProductType.find_by_name("computadoras").properties.find_by_name("HDD").property_values.find_by_value("500 Gb"),
    ProductType.find_by_name("computadoras").properties.find_by_name("marca").property_values.find_by_value("Toshiba")
  ]
)

Retailer.create(
  :name => "Fravega",
  :country => Country.find_by_name("Argentina")
)

Retailer.create(
  :name => "Garbarino",
  :country => Country.find_by_name("Argentina")
)

Retailer.create(
  :name => "Falabella",
  :country => Country.find_by_name("Chile")
)

Retailer.create(
  :name => "La Polar",
  :country => Country.find_by_name("Chile")
)
