class Property < ActiveRecord::Base
  belongs_to :product_type
  has_many :property_values
end
