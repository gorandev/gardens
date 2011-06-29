object @price
attributes :price
glue :item do
	attributes :id => :item
end
glue :currency do
	attributes :name => :currency
end
code :price_date do |p|
	p.price_date || p.created_at
end