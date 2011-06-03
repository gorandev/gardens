class ItemsController < ApplicationController
  respond_to :json
  
  def index
    @items = Item.all
    respond_with(@items)
  end
  
  def show
    @Item = Item.find(params[:id])
    respond_with(@Item)
  end

  def create
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
  
    item = Item.new(
      :retailer => Retailer.find_by_id(params[:retailer]),
      :product => Product.find_by_id(params[:product]),
      :property_values => property_values
    )
   
    if params.has_key?(:product) && item.product == nil
      return render :json => { :errors => { :product => "must be valid" } }, :status => 400
    end
   
    if item.save
      render :json => "OK"
    else
      if params.has_key?(:retailer) && item.retailer == nil
        item.errors.add(:retailer, "must be valid")
      end
      if params.has_key?(:property_values) && item.property_values.empty? && item.property_values.size != pv_param_size
        item.errors.add(:property_values, "must be all valid")
      end
      render :json => { :errors => item.errors }, :status => 400
    end
  end
  
  def update
    unless item = Item.find_by_id(params[:id])
      return render :json => { :errors => { :id => "must be valid" } }
    end

    if params.has_key?(:retailer) 
      unless retailer = Retailer.find_by_id(params[:retailer])
        return render :json => { :errors => { :retailer => "must be valid" } }, :status => 400
      end
      item.retailer = retailer
    end
    
    if params.has_key?(:product)
      unless product = Product.find_by_id(params[:product])
        return render :json => { :errors => { :product => "must be valid" } }, :status => 400
      end
      item.product = product
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
          item.property_values << property_values
        else
          item.property_values = property_values
        end
      end
    end
    
    if item.save
      render :json => "OK"
    else
      render :json => { :errors => item.errors }, :status => 400
    end
  end
  
  def destroy
    begin
      item = Item.find(params[:id])
    rescue
      return render :json => "ERROR: no valid item id"
    end
    
    item.destroy
    render :json => "OK"
  end
end