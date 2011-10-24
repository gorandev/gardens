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
#

class MediaChannel < ActiveRecord::Base
	belongs_to :media_channel_type
	belongs_to :country
	has_many :sales
end
