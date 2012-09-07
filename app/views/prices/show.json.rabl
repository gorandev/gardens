object @price
cache @price
attributes :price, :price_date
glue @item do
	cache @item
	attributes :id => :item
	glue @retailer do
		cache @retailer
		attributes :name => :retailer, :color => :retailer_color
	end
	glue @product do
		cache @product
		attributes :id => :id_product, :descripcion => :name_product
	end
end
glue @currency do
	cache @currency
	attributes :name => :currency
end