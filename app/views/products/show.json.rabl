object @product
attributes :id
child :active_in_countries => :active_in_countries do
	attributes :id => :country_id, :name => :country_name
end
child :active_in_retailers => :active_in_retailers do
	attributes :id => :retailer_id, :name => :retailer_name
	glue :country do
		attributes :id => :country_id, :name => :country_name
	end
end
glue :product_type do
	attributes :id => :product_type_id, :name => :product_type_name
end
child :property_values do
	attributes :id, :value
	glue :property do
		attributes :id => :property_id, :name => :property_name
	end
end