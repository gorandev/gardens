object @item
attributes :id, :source, :url
glue :product do
	attributes :id => :product
end
glue :retailer do
	attributes :name => :retailer
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