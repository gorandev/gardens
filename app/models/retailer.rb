# == Schema Information
# Schema version: 20110518192154
#
# Table name: retailers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Retailer < ActiveRecord::Base
  belongs_to :country
  has_many :items
  has_many :products, :through => :items
  
  validates_presence_of :name, :country
  
  def as_json(options = {})
    {
      :id => self.id,
      :name => self.name,
      :country => self.country.name
    }
  end
  
end
