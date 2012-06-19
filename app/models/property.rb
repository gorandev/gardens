# == Schema Information
#
# Table name: properties
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  product_type_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  description     :string(255)
#

class Property < ActiveRecord::Base
  belongs_to :product_type
  has_many :property_values
  validates_presence_of :name, :product_type
end

