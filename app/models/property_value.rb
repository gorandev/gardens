# == Schema Information
# Schema version: 20110509154638
#
# Table name: property_values
#
#  id          :integer         not null, primary key
#  value       :string(255)
#  property_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class PropertyValue < ActiveRecord::Base
  belongs_to :property
  has_and_belongs_to_many :products
  validates_presence_of :value, :property
  
  def as_json(options = {})
    {
      :id => self.id,
      :value => self.value,
      :property => self.property.name,
      :product_type => self.property.product_type.name
    }
  end
  
end
