object @price
attributes :price, :price_date
glue :item do
	attributes :id => :item
	glue :retailer do
		attributes :name => :retailer, :color => :retailer_color
	end
	glue :product do
		attributes :id => :id_product, :descripcion => :name_product
	end
end
glue :currency do
	attributes :name => :currency
end