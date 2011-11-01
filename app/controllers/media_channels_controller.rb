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
			:retailer => Retailer.find_by_id(params[:retailer]),
			:media_channel_type => MediaChannelType.find_by_id(params[:media_channel_type])
		)

		unless media_channel.country.nil? ^ media_channel.retailer.nil?
			if media_channel.country.nil?
				render :json => { :errors => {
					:country => [ "can't be blank if retailer is blank" ],
					:retailer => [ "can't be blank if country is blank" ]
				} }
			else
				render :json => { :errors => {
					:country => [ "can't be set if retailer isn't blank" ],
					:retailer => [ "can't be set if country isn't blank" ]
				} }
			end
			return
		end

		if media_channel.save
			render :json => { :id => media_channel.id }
		else
			if params.has_key?(:media_channel_type) && media_channel.media_channel_type.nil?
				media_channel.errors.add(:media_channel_type, "must be valid")
			end
			render :json => { :errors => media_channel.errors }, :status => 400
		end
	end
end
