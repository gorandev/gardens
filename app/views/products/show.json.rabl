object @product
attributes :id
glue :product_type do
	attributes :id => :product_type_id, :name => :product_type_name
end
child :items => :active_in_countries do
	glue :retailer do
		glue :country do
			attributes :id => :country_id, :name => :country_name
		end
	end
end
child :property_values do
	attributes :id, :value
	glue :property do
		attributes :id => :property_id, :name => :property_name
	end
end