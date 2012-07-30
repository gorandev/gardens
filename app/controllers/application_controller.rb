class ApplicationController < ActionController::Base
  # protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  before_filter :authenticate_user!, :set_globales

  def create_item(params)
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
        return render :json => { :errors => { :property_values => "must be all valid" } }, :status => 400
      end
    end

    if params.has_key?(:product) && Product.find_by_id(params[:product]).nil?
      return render :json => { :errors => { :product => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:url) and params[:url].is_a?String
      item = Item.find_or_initialize_by_url(params[:url].encode("UTF-8"))
    else
      item = Item.new()
    end
    
    item.retailer = Retailer.find_by_id(params[:retailer]) || item.retailer
    item.product = Product.find_by_id(params[:product]) || item.product
    item.product_type = ProductType.find_by_id(params[:product_type]) || item.product_type
    item.source = params[:source].encode("UTF-8") || item.source
    if params.has_key?(:description) and params[:description].is_a?String
      item.description = params[:description].encode("UTF-8") || item.description
    end
    item.imagen_id = params[:imagen_id] || item.imagen_id
    
    if property_values.size
      item.property_values = property_values
    end

    unless item.save
      if params.has_key?(:retailer) && item.retailer.nil?
        item.errors.add(:retailer, "must be valid")
      end
      if params.has_key?(:product_type) && item.product_type.nil?
        item.errors.add(:errors, "must be valid")
      end
    end

    return item
  end

  def make_priceband(pricebands, objects)
    result_pricebands = Array.new
    pricebands.each do |p|
      result_pricebands.push(0)
    end
    objects.each do |o|
      pricebands.each_with_index do |p, i|
        unless p[0].nil? and p[1].nil?
          if p[0].nil? and o.price < p[1]
            result_pricebands[i] += 1
          end
          if p[1].nil? and o.price > p[0]
            result_pricebands[i] += 1
          end
          unless p[0].nil? or p[1].nil?
            if (o.price > p[0] && o.price < p[1])
              result_pricebands[i] += 1
            end
          end
        end
      end
    end

    @resultado = OpenStruct.new({
      :pricebands => pricebands,
      :result_pricebands => result_pricebands
    })

    render 'layouts/pricebands'
  end

  def make_pie_chart(products, property)
    valores = Hash.new

    products.each do |p|
      pv = p.get_property_value(property)
      unless valores.has_key?(pv)
        valores[pv] = 1
      else
        valores[pv] += 1
      end
    end

    @resultado = OpenStruct.new({
      :pie_chart => valores
    })

    render 'layouts/pie_charts'
  end

  def make_pie_chart_sales(sales, property)
    valores = Hash.new

    sales.each do |s|
      if property == 'medio'
        valor = s.media_channel.name
      elsif property == 'retailer'
        valor = s.retailer.name
      end
      unless valores.has_key?(valor)
        valores[valor] = 1
      else
        valores[valor] += 1
      end
    end

    @resultado = OpenStruct.new({
      :pie_chart => valores
    })

    render 'layouts/pie_charts'
  end

  private
 
  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  protected

  def set_globales
    @countries = Country.all
    if params.has_key?(:country_id) and Country.find_by_id(params[:country_id])
      session[:country_id] = params[:country_id]
    else
      unless session.has_key?(:country_id) and Country.find_by_id(session[:country_id])
        session[:country_id] = 1
      end
    end
    if params.has_key?(:product_type_id) and ProductType.find_by_id(params[:product_type_id])
      session[:product_type_id] = params[:product_type_id]
    else
      unless session.has_key?(:product_type_id) and ProductType.find_by_id(session[:product_type_id])
        session[:product_type_id] = 1
      end
    end
    @country_id = session[:country_id]
    @product_type_id = session[:product_type_id]
  
    if Country.find_by_id(@country_id)
      @currency_id = Country.find(@country_id).currency.id
    end

    @hostname = Settings['host']
    @bucket = Settings['aws_bucket']

    @offset = params[:offset] || 0
    @count = params[:count] || 16

    if current_user and current_user.administrator
      @usuario_admin = 1
    end
  end
end
