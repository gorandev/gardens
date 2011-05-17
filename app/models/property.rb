# == Schema Information
# Schema version: 20110509154638
#
# Table name: properties
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  product_type_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Property < ActiveRecord::Base
  belongs_to :product_type
  has_many :property_values
  validates_presence_of :name, :product_type
  
  def as_json(options = {})
    {
      :id => self.id,
      :name => self.name,
      :product_type => self.product_type.name,
      :possible_values => self.property_values.all.collect{|pv| {
        :value => pv.value
      }}
    }
  end
  
end
