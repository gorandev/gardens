class PricesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json
  
  def index
    @prices = Price.limit(@count).offset(@offset)
    respond_with(@prices)
  end
  
  def show
    @price = Price.find(params[:id])
    respond_with(@price)
  end
  
  def create
    if params.has_key?(:url)
      item = create_item(params)

      unless item.is_a?Item
        return item
      end
      
      unless item.errors.empty?
        return render :json => { :errors => item.errors }, :status => 400
      end
      
      params[:item] = item.id
    end

    unless params.has_key?(:price_date)
      params[:price_date] = Date.current
    end
    
    ultimo_precio = Price.where(:item_id => params[:item]).order(:price_date).last
    unless (ultimo_precio.nil?)
      unless ultimo_precio.price_date <= params[:price_date].to_date
        ultimo_precio = nil
      end
    end
    
    price = Price.find_or_initialize_by_item_id_and_price_date(params[:item], params[:price_date])
    price.price = params[:value]
    price.currency = Currency.find_by_id(params[:currency])
    
    if price.save
      if (params.has_key?(:scraped) && !ultimo_precio.nil? && price.price != ultimo_precio.price)
        Event.create(
          :item => price.item,
          :precio_viejo => ultimo_precio.price,
          :precio_nuevo => price.price
        )
      end
      unless price.item.product_id.nil?
        REDIS.sadd "producto_precio:#{price.item.product.id}_#{price.currency}", price.id
      end
      render :json => { :id => price.id }
    else
      if params.has_key?(:item) && price.item == nil
        price.errors.add(:item, "must be valid")
      end
      if params.has_key?(:currency) && price.currency == nil
        price.errors.add(:currency, "must be valid")
      end
      render :json => { :errors => price.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:product, :item, :retailer, :currency, :date_from, :date_to).empty?
      return render :json => { :errors => { :price => "no search parameters" } }, :status => 400
    end

    if params.slice(:currency, :product, :date_from, :no_limit).size == 4
      fecha_inicial = Date.parse(params[:date_from])
      fecha_final = (params.has_key?(:date_to)) ? Date.parse(params[:date_to]) : Time.now.to_date

      unless params[:product].is_a?Array
        params[:product] = params[:product].split(',')
      end

      #@pricepoints = PricePoint.any_in(:id_product => params[:product]).where(:price_date => { '$gte' => fecha_inicial, '$lt' => fecha_final }, :currency => Currency.find(params[:currency]).name).ascending(:price_date)
      @pricepoints = PricePoint.where(:id_product => { '$in' => params[:product] }, :price_date => { '$gte' => fecha_inicial, '$lt' => fecha_final }, :currency => Currency.find(params[:currency]).name).ascending(:price_date)
      render :json => @pricepoints, :callback => params[:callback]
      return
    end

    # if params.slice(:currency, :product, :date_from, :no_limit).size == 4
    #   fecha_inicial = Date.parse(params[:date_from])
    #   fecha_final = (params.has_key?(:date_to)) ? Date.parse(params[:date_to]) : Time.now.to_date

    #   unless params[:product].is_a?Array
    #     params[:product] = params[:product].split(',')
    #   end

    #   prods_redis_key = Array.new
    #   params[:product].each do |p|
    #     prods_redis_key.push('producto_precio:' + p + '_' + params[:currency])
    #   end

    #   @prices = Price.includes(:currency, :item => [ :retailer, :product ]).where(:id => REDIS.sunion(*prods_redis_key)).where('price_date between ? and ?', fecha_inicial, fecha_final)
    #   return
    # end

    where = Hash.new
    join = Array.new
    
    if params.has_key?(:item)
      unless Item.exists?(params[:item])
        return render :json => { :errors => { :item => "not found" } }, :status => 400
      end
      where[:item_id] = params[:item]
    end

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

      if join.index(:item).nil?
        join.push(:item)
      end
      
      if where.has_key?(:items)
        where[:items][:product_id] = params[:product]
      else
        where[:items] = { :product_id => params[:product] }
      end
    end

    if params.has_key?(:retailer)
      unless Retailer.exists?(params[:retailer])
        return render :json => { :errors => { :retailer => "not found" } }, :status => 400
      end
      
      if join.index(:item).nil?
        join.push(:item)
      end

      if where.has_key?(:items)
        where[:items][:retailer_id] = params[:retailer]
      else
        where[:items] = { :retailer_id => params[:retailer] }
      end
    end
    
    params[:date_to] ||= DateTime.now
    params[:date_from] ||= "2000-01-01".to_datetime
    where[:price_date] = (params[:date_from].to_datetime)..(params[:date_to].to_datetime + 1.day)

    if params.has_key?(:no_limit)
      @prices = Price.includes(:currency, :item => [ :retailer, :product ]).joins(join).where(where).order("price_date ASC")
    else
      @prices = Price.includes(:currency, :item => [ :retailer, :product ]).joins(join).where(where).limit(@count).offset(@offset).order("price_date DESC")
    end
  end
end