# == Schema Information
#
# Table name: rules
#
#  id           :integer         not null, primary key
#  alert_id     :integer
#  value        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  rule_type_id :integer
#

class Rule < ActiveRecord::Base
  belongs_to :alert
  belongs_to :rule_type

  validates :alert_id, :rule_type_id, :presence => true
end
