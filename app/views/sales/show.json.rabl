object @sale
attributes :id, :sale_date, :price, :origin, :units_available, :valid_since, :valid_until, :bundle, :page, :imagen_id
glue :media_channel do
	attributes :name => :media_channel
end
glue :retailer do
	attributes :name => :retailer
end
glue :product do
	attributes :id => :id_product, :descripcion => :descripcion
end
glue :currency do
	attributes :id => :currency_id
end