object @property_value
attributes :id, :value
glue :property do
	attributes :id => :property_id, :name => :property_name
	glue :product_type do
		attributes :id => :product_type_id, :name => :product_type_name
	end
end