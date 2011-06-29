object @retailer
attributes :id, :name
glue :country do
	attributes :name => :country
end