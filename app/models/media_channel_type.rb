# == Schema Information
#
# Table name: media_channel_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MediaChannelType < ActiveRecord::Base
	has_many :media_channels
	validates_presence_of :name
end

