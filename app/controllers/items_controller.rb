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

  def actions
    if params.has_key?("product")
      return associate
    end
  end
  
  def create   
    begin
      retailer = Retailer.find(params[:retailer])
    rescue
    end

    pvs = Array.new
    begin
      params[:property_values].split(",").each do |pv|
        begin
          pvs.push(PropertyValue.find(pv))
        rescue
        end
      end
    rescue
    end
    
    begin
      product = Product.find(params[:product])
      item = Item.new( :product => product, :retailer => retailer )
    rescue
      item = Item.new( :retailer => retailer )
    end
   
    item.property_values << pvs
   
    if item.save
      render :json => "OK"
    else
      render :json => { :errors => item.errors }
    end
  end
  
  def update
    begin
      item = Item.find(params[:id])
    rescue
      return render :json => "ERROR: no valid item id"
    end
    
    unless params.has_key?("product") || params.has_key?("retailer") || params.has_key?("property_values")
      return render :json => "ERROR: nothing to update"
    end
    
    if params.has_key?("retailer")
      begin
        retailer = Retailer.find(params[:retailer])
      rescue
        return render :json => "ERROR: invalid retailer"
      end
      
      item.retailer = retailer
    end
      
    if params.has_key?("product")
      begin
        product = Product.find(params[:product])
      rescue
        return render :json => "ERROR: invalid product"
      end
      
      item.product = product
    end
    
    if params.has_key?("property_values")
      pvs = Array.new
      pvs_params = Array.new
    
      if params[:property_values].is_a?Array
        pvs_params = params[:property_values]
      else
        pvs_params = params[:property_values].split(",")
      end

      pvs_params.each do |pv|
        begin
          pvs.push(PropertyValue.find(pv))
        rescue
          return render :json => "ERROR: invalid property value"
        end
      end
      
      if pvs.empty?
        return render :json => "ERROR: invalid property value"
      end
      
      item.property_values = pvs
    end
    
    if item.save
      render :json => "OK"
    else
      render :json => "ERROR: could not save"
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