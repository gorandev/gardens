object @price
attributes :price, :price_date
glue :item do
	attributes :id => :item
	glue :retailer do
		attributes :name => :retailer
	end
end
glue :currency do
	attributes :name => :currency
end