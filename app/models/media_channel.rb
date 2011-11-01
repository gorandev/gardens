# == Schema Information
#
# Table name: media_channels
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  media_channel_type_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#  country_id            :integer
#  retailer_id           :integer
#

class MediaChannel < ActiveRecord::Base
	belongs_to :media_channel_type
	belongs_to :country
	belongs_to :retailer
	has_many :sales

	validates_presence_of :name, :media_channel_type
end
