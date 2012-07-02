# == Schema Information
#
# Table name: alerts
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Alert < ActiveRecord::Base
	belongs_to :event
	belongs_to :user
	has_many :rules

	validates :user_id, :presence => true

	def ruletype_signature
		 self.rules.sort{|a,b| a.rule_type.description + (a.value.nil? ? '0' : a.value) <=> b.rule_type.description + (b.value.nil? ? '0' : b.value)}.map {|r| r.rule_type.description+(r.value.nil? ? '0' : r.value)}.join(',')
	end
end
