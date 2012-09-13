class PricePoint
  include Mongoid::Document
  field :price, type: Integer
  field :price_date, type: Date
  field :item, type: Integer
  field :retailer, type: String
  field :retailer_color, type: String
  field :id_product, type: Integer
  field :name_product, type: String
  field :currency, type: String
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  index(
    [
      [ :id_product, Mongo::ASCENDING ],
      [ :price_date, Mongo::ASCENDING ],
      [ :currency, Mongo::ASCENDING ]
    ]
  )
end