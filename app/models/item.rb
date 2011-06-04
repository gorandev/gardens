# == Schema Information
# Schema version: 20110603204022
#
# Table name: items
#
#  id          :integer         not null, primary key
#  product_id  :integer
#  retailer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  source      :string(255)
#

class Item < ActiveRecord::Base
  belongs_to :product
  belongs_to :retailer
  
  has_and_belongs_to_many :property_values
  has_many :prices
  
  validates_presence_of :retailer, :property_values, :source
  validates_inclusion_of :source, :in => %w(web papel)
  
  def as_json(options = {})
    if self.product.nil?
      {
        :id => self.id,
        :retailer => self.retailer.name,
        :product => 0,
        :source => self.source,
        :property_values => self.property_values.all.collect{|pv| {
        :id => pv.property.id,
        :name => pv.property.name,
        :value_id => pv.id,
        :value => pv.value
        }}
      }
    else
      {
        :id => self.id,
        :retailer => self.retailer.name,
        :product => self.product.id,
        :source => self.source
      }
    end
  end
end
