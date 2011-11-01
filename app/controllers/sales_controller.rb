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
			:currency => Currency.find_by_id(params[:currency]),
			:imagen_id => params[:imagen_id]
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

  def search    
    if params.slice(:product, :currency, :date_from, :date_to).empty?
      return render :json => { :errors => { :price => "no search parameters" } }, :status => 400
    end

    where = Hash.new
    join = Array.new

    if params.has_key?(:currency)
      unless Currency.exists?(params[:currency])
        return render :json => { :errors => { :currency => "not found" } }, :status => 400
      end
      where[:currency_id] = params[:currency]
    end
    
    if params.has_key?(:product)
      unless params[:product].is_a?Array
        params[:product] = params[:product].split(',')
      end
      where[:product_id] = params[:product]
    end
    
    params[:date_to] ||= DateTime.now
    params[:date_from] ||= "2000-01-01".to_datetime
    where[:sale_date] = (params[:date_from].to_datetime)..(params[:date_to].to_datetime + 1.day)

    @sales = Sale.includes(:media_channel, :retailer, :product).where(where).order("sale_date DESC")
  end
end
