# == Schema Information
#
# Table name: saved_reports
#
#  id          :integer         not null, primary key
#  querystring :text
#  orden       :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class SavedReport < ActiveRecord::Base
	belongs_to :user
end