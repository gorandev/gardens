class ProductsController < ApplicationController
  respond_to :json

  def index
    @products = Product.all(
      :include => [
        :product_type,
        { :items => { :retailer => :country } },
        { :property_values => :property }
      ]
    )
  end
  
  def show
    @product = Product.find(params[:id])
  end
  
  def new
    @product = Product.new
    @product.property_values.build
  end

  def create
    if params.has_key?("product")
      return create_from_form
    end

    property_values = Array.new
    if params.has_key?(:property_values)
      if params[:property_values].is_a?String
        property_values = PropertyValue.find_all_by_id(params[:property_values].split(','))
        pv_param_size = params[:property_values].split(',').size
      else
        if params[:property_values].is_a?Array
          pv_param_size = params[:property_values].size
        end
        property_values = PropertyValue.find_all_by_id(params[:property_values])
      end

      if property_values.size != pv_param_size
        property_values.clear
      end
    end
    
    product = Product.new(
      :product_type => ProductType.find_by_id(params[:product_type]), 
      :property_values => property_values,
      :imagen_id => params[:imagen_id]
    )
    
    if product.save
      render :json => { :id => product.id }
    else
      if params.has_key?(:product_type) && product.product_type == nil
        product.errors.add(:product_type, "must be valid")
      end
      if params.has_key?(:property_values) && product.property_values.empty?
        product.errors.add(:property_values, "must be all valid")
      end
      render :json => { :errors => product.errors }, :status => 400
    end
  end

  def create_from_form
    pvs = Array.new
    begin
      params[:product][:property_values].each_index do |pv|
        begin
          pvs.push(PropertyValue.find(params[:product][:property_values][pv]))
        rescue
        end
      end
    rescue
    end
    params[:product][:property_values] = pvs
    @product = Product.new(params[:product])
    @product.valid?
    unless pvs.length > 0
      if @product.errors.empty?
        @product.errors[:product_type] = "select at least one property value"
      end
      render :action => "new"
    else
      if @product.save
        flash[:notice] = "Salvado con exito"
        redirect_to :action => "new"
      else 
        render :action => "new"
      end
    end
  end
  
  def update
    unless product = Product.find_by_id(params[:id])
      return render :json => { :errors => { :product => "must be valid" } }, :status => 400
    end

    if params.has_key?(:product_type)
      unless product_type = ProductType.find_by_id(params[:product_type])
        return render :json => { :errors => { :product_type => "must be valid" } }, :status => 400
      end
      product.product_type = product_type
    end

    if params.has_key?(:property_values)
      if params[:property_values].is_a?String
        property_values = PropertyValue.find_all_by_id(params[:property_values].split(','))
        pv_param_size = params[:property_values].split(',').size
      else
        if params[:property_values].is_a?Array
          pv_param_size = params[:property_values].size
        end
        property_values = PropertyValue.find_all_by_id(params[:property_values])
      end
      
      if property_values.empty? || property_values.size != pv_param_size
        return render :json => { :errors => { :property_values => "must be all valid" } }, :status => 400
      else
        if params[:property_values].is_a?String
          product.property_values << property_values
        else
          product.property_values = property_values
        end
      end
    end
    
    if product.save
      render :json => "OK"
    else
      render :json => { :errors => product.errors }, :status => 400
    end
  end
  
  def destroy
    unless product = Product.find_by_id(params[:id])
      return render :json => { :errors => { :product => "must be valid" } }
    end
    
    product.destroy
    render :json => "OK"
  end
  
  def search    
    if params.slice(:product_type, :property_values, :retailers, :country).empty?
      return render :json => { :errors => { :product => "no search parameters" } }, :status => 400
    end

    intersect = Array.new

    if params.has_key?(:product_type)
      if ProductType.find_by_id(params[:product_type])
        params[:product_type_id] = params[:product_type]
      else
        return render :json => { :errors => { :product_type => "not found" } }, :status => 400
      end

      intersect.push('product_type:' + params[:product_type].to_s)
    end

    if params.has_key?(:country)
      unless Country.find_by_id(params[:country])
        return render :json => { :errors => { :country => "not found" } }, :status => 400
      end

      intersect.push('country:' + params[:country].to_s)
    end

    if params.has_key?(:retailers)
      if params[:retailers].is_a?String
        unless params[:retailers].split(',').size > 0 && Retailer.find_all_by_id(params[:retailers].split(',')).size == params[:retailers].split(',').size
          return render :json => { :errors => { :retailers => "not found" } }, :status => 400
        end
        params[:retailers] = params[:retailers].split(',')
      elsif params[:retailers].is_a?Array
        unless params[:retailers].size > 0 && Retailer.find_all_by_id(params[:retailers]).size == params[:retailers].size
          return render :json => { :errors => { :retailers => "not found" } }, :status => 400
        end
      else
        return render :json => { :errors => { :property_values => "must be comma-separated string or JSON array" } }, :status => 400
      end

      params[:retailers].each do |r|
        intersect.push('retailer:' + r.to_s)
      end
    end

    if params.has_key?(:property_values)
      if params[:property_values].is_a?String
        unless params[:property_values].split(',').size > 0 && PropertyValue.find_all_by_id(params[:property_values].split(',')).size == params[:property_values].split(',').size
          return render :json => { :errors => { :property_values => "not found" } }, :status => 400
        end
        params[:property_values] = params[:property_values].split(',')
      elsif params[:property_values].is_a?Array
        unless params[:property_values].size > 0 && PropertyValue.find_all_by_id(params[:property_values]).size == params[:property_values].size
          return render :json => { :errors => { :property_values => "not found" } }, :status => 400
        end
      else
        return render :json => { :errors => { :property_values => "must be comma-separated string or JSON array" } }, :status => 400
      end

      params[:property_values].each do |pv|
        intersect.push('property_value:' + pv.to_s)
      end
    end

    if intersect.empty?
      @products = Product.all(
        :include => [
          :product_type,
          { :items => { :retailer => :country } },
          { :property_values => :property }
        ]
      )
    else
      redis = Redis.new
      @products = Product.find_all_by_id(
        redis.sinter(*intersect),
        :include => [
          :product_type,
          { :items => { :retailer => :country } },
          { :property_values => :property }
        ]
      )
    end
  end
  
  def prices 
    # TODO: este bloque habría que hacerlo siempre (en todas las acciones que muestran una página) #
    @countries = Country.all
    if params.has_key?(:country_id) && Country.find_by_id(params[:country_id])
      session[:country_id] = params[:country_id]
    else
      unless session.has_key?(:country_id) && Country.find_by_id(session[:country_id])
        session[:country_id] = 2 # TODO: esto debería inicializarse al login
      end
    end
    @country_id = session[:country_id]

    @pagina = 'Precios'

    @properties = Array.new
    Settings['computadoras']['precios'].each do |p|
      @properties.push({
        :name => p["name"],
        :field => p["field"],
        :id => Property.find_by_name(p["field"]).id
      })
    end
  end

  def inicializar_memstore
    redis = Redis.new
    redis.flushall
    Product.all.each do |p|
      redis.sadd 'product_type:' + p.product_type.id.to_s, p.id
      p.active_in_countries.each do |c|
        redis.sadd 'country:' + c.id.to_s, p.id
      end
      p.active_in_retailers.each do |r|
        redis.sadd 'retailer:' + r.id.to_s, p.id
      end
      p.property_values.all.each do |pv|
        redis.sadd 'property_value:' + pv.id.to_s, p.id
        redis.sadd 'product:' + p.id.to_s, pv.id
      end
    end
  end
end