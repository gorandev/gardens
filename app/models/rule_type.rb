# == Schema Information
#
# Table name: rule_types
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class RuleType < ActiveRecord::Base
	has_many :rules
	validates :description, :presence => true, :uniqueness => true
end
