# == Schema Information
# Schema version: 20110513001904
#
# Table name: products
#
#  id              :integer         not null, primary key
#  status          :string(255)
#  product_type_id :integer
#  show_on_search  :boolean
#  created_at      :datetime
#  updated_at      :datetime
#

class Product < ActiveRecord::Base
  belongs_to :product_type
  has_and_belongs_to_many :property_values
  has_many :items
  has_many :retailers, :through => :items
  
  validates_presence_of :product_type, :property_values
  
  def as_json(options = {})
    {
      :id => self.id,
      :product_type => self.product_type.name,
      :active_in_countries => "TBD",
      :property_values => self.property_values.all.collect{|pv| {
        :id => pv.property.id,
        :name => pv.property.name,
        :value_id => pv.id,
        :value => pv.value
      }}
    }
  end
  
end