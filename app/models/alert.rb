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
end
