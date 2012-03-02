# == Schema Information
#
# Table name: property_values
#
#  id          :integer         not null, primary key
#  value       :string(255)
#  property_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  word_id     :integer
#

class PropertyValue < ActiveRecord::Base
  belongs_to :property
  belongs_to :word
  has_and_belongs_to_many :products
  has_and_belongs_to_many :items
  validates_presence_of :value, :property
end

