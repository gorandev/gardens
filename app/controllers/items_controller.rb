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
   
    if !params.has_key?("product")
      return render :json => "ERROR: no product"
    end

    if !params.has_key?("retailer")
      return render :json => "ERROR: no retailer"
    end
    
    begin
      product = Product.find(params[:product])
    rescue
      return render :json => "ERROR: no valid product type"
    end

    begin
      retailer = Retailer.find(params[:retailer])
    rescue
      return render :json => "ERROR: no valid retailer type"
    end
    
    item = Item.new( :product => product, :retailer => retailer )
    
    if item.save
      render :json => "OK"
    else
      render :json => "ERROR: item wasn't saved"
    end
  end
end
