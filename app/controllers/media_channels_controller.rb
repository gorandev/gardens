class MediaChannelsController < ApplicationController
	respond_to :json

	def index
		@media_channels = MediaChannel.all
	end

	def show
		@media_channel = MediaChannel.find(params[:id])
	end

	def create
		media_channel = MediaChannel.new(
			:name => params[:name], 
			:country => Country.find_by_id(params[:country]),
			:media_channel_type => MediaChannelType.find_by_id(params[:media_channel_type])
		)

		if media_channel.save
			render :json => { :id => media_channel.id }
		else
			if params.has_key?(:country) && media_channel.country.nil?
				media_channel.errors.add(:country, "must be valid")
			end
			if params.has_key?(:media_channel_type) && media_channel.media_channel_type.nil?
				media_channel.errors.add(:media_channel_type, "must be valid")
			end
			render :json => { :errors => media_channel.errors }, :status => 400
		end
	end
end
