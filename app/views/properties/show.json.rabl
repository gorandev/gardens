object @property
attributes :id, :name, :description
glue :product_type do
	attributes :id => :product_type_id, :name => :product_type_name
end
child :property_values => :possible_values do
	attributes :id, :value
end