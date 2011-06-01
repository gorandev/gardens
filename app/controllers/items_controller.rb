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
    if params[:property_values].is_a?String
      property_values = PropertyValue.find_all_by_id(params[:property_values].split(','))
    else
      property_values = PropertyValue.find_all_by_id(params[:property_values])
    end
  
    item = Item.new(
      :retailer => Retailer.find_by_id(params[:retailer]),
      :product => Product.find_by_id(params[:product]),
      :property_values => property_values
    )
   
    if item.save
      render :json => "OK"
    else
      render :json => { :errors => item.errors }
    end
  end
  
  def update
    unless item = Item.find_by_id(params[:id])
      return render :json => { :errors => { :id => "must be valid" } }
    end

    if retailer = Retailer.find_by_id(params[:retailer])
      item.retailer = retailer
    end
    
    if product = Product.find_by_id(params[:product])
      item.product = product
    end

    if params[:property_values].is_a?String
      property_values = PropertyValue.find_all_by_id(params[:property_values].split(','))
    else
      property_values = PropertyValue.find_all_by_id(params[:property_values])
    end
    
    if !property_values.empty?
      item.property_values = property_values
    end

    if item.save
      render :json => "OK"
    else
      render :json => { :errors => item.errors }
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