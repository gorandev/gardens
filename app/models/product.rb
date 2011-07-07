# == Schema Information
# Schema version: 20110618000754
#
# Table name: products
#
#  id              :integer         not null, primary key
#  status          :string(255)
#  product_type_id :integer
#  show_on_search  :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  imagen_id       :integer
#

class Product < ActiveRecord::Base
  belongs_to :product_type
  has_and_belongs_to_many :property_values
  has_many :items
  has_many :retailers, :through => :items
  
  validates_presence_of :product_type, :property_values
end