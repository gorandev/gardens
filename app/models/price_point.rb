class PricePoint
  include Mongoid::Document
  cache
  field :id_postgres, type: Integer
  field :price, type: Integer
  field :price_date, type: Date
  field :item, type: Integer
  field :retailer, type: String
  field :retailer_color, type: String
  field :id_product, type: Integer
  field :name_product, type: String
  field :currency, type: String

  index :id_postgres, unique: true

  index(
    [
      [ :id_product, Mongo::ASCENDING ],
      [ :price_date, Mongo::ASCENDING ],
      [ :currency, Mongo::ASCENDING ]
    ]
  )

  def create_from_price(price)
    PricePoint.create(
      :id_postgres => price.id,
      :price => price.price, 
      :price_date => price.price_date,
      :item => price.item.id,
      :retailer => price.item.retailer.name,
      :retailer_color => price.item.retailer.color,
      :id_product => price.item.product.id,
      :name_product => price.item.product.descripcion,
      :currency => price.currency.name
    )
  end
end