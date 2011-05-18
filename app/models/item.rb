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
  has_many :prices
  
  validates_presence_of :product, :retailer
  
  def as_json(options = {})
    {
      :id => self.id,
      :retailer => self.retailer.name,
      :product => self.product.id
    }
  end
  
end
