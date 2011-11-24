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
    
    item = Item.find_or_initialize_by_url(params[:url])
    
    item.retailer = Retailer.find_by_id(params[:retailer]) || item.retailer
    item.product = Product.find_by_id(params[:product]) || item.product
    item.product_type = ProductType.find_by_id(params[:product_type]) || item.product_type
    item.source = params[:source] || item.source
    item.description = params[:description] || item.description
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

  private
 
  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  protected

  def set_globales
    @countries = Country.all
    if params.has_key?(:country_id) && Country.find_by_id(params[:country_id])
      session[:country_id] = params[:country_id]
    else
      unless session.has_key?(:country_id) && Country.find_by_id(session[:country_id])
        session[:country_id] = 1
      end
    end
    @country_id = session[:country_id]
    @currency_id = Country.find(@country_id).currency.id
  end
end