# == Schema Information
#
# Table name: prices
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  price_date  :date
#  currency_id :integer
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Price < ActiveRecord::Base
  belongs_to :item
  belongs_to :currency
  
  validates_presence_of :item, :currency, :price, :price_date
  validates_uniqueness_of :price_date, :scope => :item_id
end

