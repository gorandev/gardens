require 'ostruct'
class SalesController < ApplicationController
	respond_to :json

	def index
		@sales = Sale.limit(@count).offset(@offset)
	end

	def show
		@sale = Sale.find(params[:id])
	end

  def create_cargapromos
    self.create
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
			:imagen_id => params[:imagen_id],
      :aws_filename => params[:aws_filename]
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
    elsif params.has_key?(:property_values)
      unless params[:property_values].is_a?Array
        params[:property_values] = params[:property_values].split(',')
      end
      where[:product_id] = REDIS.sinter(*params[:property_values].collect {|pv| 'property_value:' + pv.to_s})
    end
    
    if params.has_key?(:media_channel)
    	unless params[:media_channel].is_a?Array
    		params[:media_channel] = params[:media_channel].split(',')
    	end
    	where[:media_channel_id] = params[:media_channel]
    end

    if params.has_key?(:retailer)
    	unless params[:retailer].is_a?Array
    		params[:retailer] = params[:retailer].split(',')
    	end
    	where[:retailer_id] = params[:retailer]
    end

    params[:date_to] ||= DateTime.now
    params[:date_from] ||= "2000-01-01".to_datetime
    where[:sale_date] = (params[:date_from].to_datetime)..(params[:date_to].to_datetime + 1.day)

    if params.has_key?(:getcount)
    	total_entries = Sale.includes(:media_channel, :retailer, :product).where(where).count
    	@total_pages = OpenStruct.new({
    		:paginas => ( (total_entries.to_i / params[:count].to_i).ceil )
    	})
    	render 'getcount' and return
    end

    if params.has_key?(:getall) or params.has_key?(:pricebands) or params.has_key?(:pie_chart)
      @count = nil
      @offset = nil
    end

  	@sales = Sale.includes(:media_channel, :retailer, :product, :currency).where(where).order("sale_date DESC").limit(@count).offset(@offset)

    if params.has_key?(:pie_chart)
      if params[:pie_chart] == 'medio' or params[:pie_chart] == 'retailer'
        return make_pie_chart_sales(@sales, params[:pie_chart])
      end

      products = Array.new
      @sales.each do |s|
        products.push(s.product)
      end
      return make_pie_chart(
        products,
        params[:pie_chart]
      )
    end

    if params.has_key?(:pricebands)
      return make_priceband(
        Settings['computadoras']['pricebands'][Currency.find(params[:currency]).country.iso_code],
        @sales
      )
    end
  end

  def ver
  	@pagina = 'Publicaciones'
    @id_producto = 0
  	if params.has_key?(:id_producto)
  		@id_producto = params[:id_producto]
  	end
  end

  def cargapromos
    @layout_grande = true
    @url_imagen_producto = Settings["product_type_#{@product_type_id}"]['url_imagen_producto']
    @orden_pvs = Settings["product_type_#{@product_type_id}"]['cargapromos']['propiedades']
  end
end