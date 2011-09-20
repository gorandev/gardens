object @retailer
attributes :id, :name, :color
glue :country do
	attributes :name => :country
end