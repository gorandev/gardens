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

  def active_in_countries
  	countries_ids = Hash.new
  	self.items.each do |i|
  		countries_ids[i.retailer.country.id] = 1
	end
  return Country.find_all_by_id(countries_ids.keys)
  end

  def active_in_retailers
    retailers_ids = Hash.new
    self.items.each do |i|
      retailers_ids[i.retailer.id] = 1
    end
    return Retailer.find_all_by_id(retailers_ids.keys)
  end
end