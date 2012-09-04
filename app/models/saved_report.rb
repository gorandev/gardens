# == Schema Information
#
# Table name: saved_reports
#
#  id              :integer          not null, primary key
#  querystring     :text
#  orden           :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  url             :text
#  product_type_id :integer
#

class SavedReport < ActiveRecord::Base
	belongs_to :user
	belongs_to :product_type
	validates_presence_of :url, :querystring, :user, :product_type_id
end
