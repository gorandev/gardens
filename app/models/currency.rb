# == Schema Information
# Schema version: 20110512233816
#
# Table name: currencies
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  symbol         :string(255)
#  decimal_places :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Currency < ActiveRecord::Base
  validates_presence_of :name, :symbol
  has_one :country
  has_many :prices
  
  def as_json(options = {})
    {
      :id => self.id,
      :name => self.name,
      :symbol => self.symbol
    }
  end
  
end
