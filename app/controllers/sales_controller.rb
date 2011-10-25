class SalesController < ApplicationController
	respond_to :json

	def index
		@sales = Sale.all
	end

	def show
		@sale = Sale.find(params[:id])
	end

	def create
		sale = Sale.new(
			:sale_date => params[:sale_date],
			:price => params[:price],
			:origin => params[:origin],
			:units_available => params[:units_available],
			:valid_since => params[:valid_since],
			:valid_until => params[:valid_until],
			:bundle => params[:bundle],
			:media_channel => MediaChannel.find_by_id(params[:media_channel]),
			:retailer => Retailer.find_by_id(params[:retailer]),
			:product => Product.find_by_id(params[:product]),
			:page => params[:page],
			:currency => Currency.find_by_id(params[:currency])
		)

		if sale.save
			render :json => { :id => sale.id }
		else
			if params.has_key?(:media_channel) && sale.media_channel.nil?
				sale.errors.add(:media_channel, "must be valid")
			end
			if params.has_key?(:retailer) && sale.retailer.nil?
				sale.errors.add(:retailer, "must be valid")
			end
			if params.has_key?(:product) && sale.product.nil?
				sale.errors.add(:product, "must be valid")
			end
			if params.has_key?(:currency) && sale.currency.nil?
				sale.errors.add(:currency, "must be valid")
			end
			render :json => { :errors => sale.errors }, :status => 400
		end
	end
end