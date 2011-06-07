# == Schema Information
# Schema version: 20110607211119
#
# Table name: prices
#
#  id          :integer         not null, primary key
#  item_id     :integer
#  price_date  :datetime
#  currency_id :integer
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Price < ActiveRecord::Base
  belongs_to :item
  belongs_to :currency
  
  validates_presence_of :item, :currency, :price
  
  def as_json(options = {})
    {
      :item => self.item.id,
      :currency => self.currency.name,
      :price => self.price,
      :price_date => self.price_date || self.created_at
    }
  end
  
end
