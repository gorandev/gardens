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

  def associate
    begin
      item = Item.find(params[:id])
    rescue
      return render :json => "ERROR: invalid item id"
    end
    
    begin
      product = Product.find(params[:product])
    rescue
      return render :json => "ERROR: invalid product id"
    end
    
    item.product = product
    if item.save
      render :json => "OK"
    else
      render :json => "ERROR: couldn't save"
    end
  end
  
  def create
    if params.has_key?("item")
      return create_from_form
    end
   
    if !params.has_key?("retailer")
      return render :json => "ERROR: no retailer"
    end
    
    begin
      retailer = Retailer.find(params[:retailer])
    rescue
      return render :json => "ERROR: no valid retailer type"
    end

    if !params.has_key?("property_values")
      return render :json => "ERROR: no property values"
    end
    
    pvs = Array.new
    params[:property_values].split(",").each do |pv|
      begin
        pvs.push(PropertyValue.find(pv))
      rescue
      end
    end
    
    if pvs.empty?
      return render :json => "ERROR: no valid property values"
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
      render :json => "ERROR: item wasn't saved"
    end
  end
  
  def update
    if params.has_key?("item")
      return create_from_form
    end
  
    unless params.has_key?("id")
      return render :json => "ERROR: no item id"
    end
    
    begin
      update_item = Item.find(params[:id])
    rescue
      return render :json => "ERROR: no valid item id"
    end
    
    unless params.has_key?("product") || params.has_key?("retailer") || params.has_key?("property_values")
      return render :json => "ERROR: nothing to update"
    end
    
    if params.has_key?("retailer")
      begin
        update_retailer = Retailer.find(params[:retailer])
      rescue
        return render :json => "ERROR: invalid retailer"
      end
      
      update_item.retailer = update_retailer
    end
      
    if params.has_key?("product")
      begin
        update_product = Product.find(params[:product])
      rescue
        return render :json => "ERROR: invalid product"
      end
      
      update_item.product = update_product
    end
    
    if params.has_key?("property_values")
      pvs = Array.new
      params[:property_values].split(",").each do |pv|
        begin
          pvs.push(PropertyValue.find(pv))
        rescue
          return render :json => "ERROR: invalid property value"
        end
      end
      
      if pvs.empty?
        return render :json => "ERROR: invalid property value"
      end
      
      update_item.property_values = pvs
    end
    
    if update_item.save
      render :json => "OK"
    else
      render :json => "ERROR: could not save"
    end
  end
end