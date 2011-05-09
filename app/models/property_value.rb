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
end
