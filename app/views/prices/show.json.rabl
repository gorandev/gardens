object @price
attributes :price, :price_date
glue :item do
	attributes :id => :item
end
glue :currency do
	attributes :name => :currency
end