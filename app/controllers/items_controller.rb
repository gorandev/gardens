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
end
