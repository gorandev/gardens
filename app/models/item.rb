# == Schema Information
# Schema version: 20110518192154
#
# Table name: items
#
#  id          :integer         not null, primary key
#  product_id  :integer
#  retailer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Item < ActiveRecord::Base
  belongs_to :product
  belongs_to :retailer
  
  has_and_belongs_to_many :property_values
  has_many :prices
  
  validates_presence_of :retailer
  
  def as_json(options = {})
  
    if self.product.nil?
      {
        :id => self.id,
        :retailer => self.retailer.name,
        :product => 0,
        :property_values => self.property_values.all.collect{|pv| {
          :id => pv.id,
          :value => pv.value
        }}
      }
    else
      {
        :id => self.id,
        :retailer => self.retailer.name,
        :product => self.product.id
      }
    end
    
  end
  
end
