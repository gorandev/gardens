object @product_type
attributes :id, :name
child :properties do
	attributes :id, :name
	child :property_values => :possible_values do
		attributes :id, :value
	end
end