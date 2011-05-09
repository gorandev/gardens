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
end
