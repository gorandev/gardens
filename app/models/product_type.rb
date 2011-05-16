# == Schema Information
# Schema version: 20110509154638
#
# Table name: product_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProductType < ActiveRecord::Base
  has_many :properties
  validates_presence_of :name
  
  def as_json(options = {})
    {
      :name => self.name,
      :id => self.id,
      :properties => self.properties.all.collect{|p| {
        :id => p.id,
        :name => p.name,
        :possible_values => p.property_values.all.collect{|pv| {
          :id => pv.id,
          :value => pv.value
        }}
      }}
    }
  end
  
end