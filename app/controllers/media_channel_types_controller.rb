class MediaChannelTypesController < ApplicationController
	respond_to :json

	def index
		@media_channel_types = MediaChannelType.all
	end

	def show
		@media_channel_type = MediaChannelType.find(params[:id])
	end

	def create
		media_channel_type = MediaChannelType.new( :name => params[:name] )
		if media_channel_type.save
			render :json => { :id => media_channel_type.id }
		else
			render :json => { :errors => media_channel_type.errors }, :status => 400
		end
	end
end
