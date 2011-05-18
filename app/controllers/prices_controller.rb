class PricesController < ApplicationController
  respond_to :json
  
  def index
    @prices = Price.all
    respond_with(@prices)
  end
  
  def show
    @Price = Price.find(params[:id])
    respond_with(@Price)
  end
  
  def create
    if params.has_key?("price")
      return create_from_form
    end

    if !params.has_key?("value")
      return render :json => "ERROR: no value"
    end
    
    if !params.has_key?("item")
      return render :json => "ERROR: no item"
    end

    begin
      item = Item.find(params[:item])
    rescue
      return render :json => "ERROR: no valid item type"
    end
    
    if !params.has_key?("currency")
      return render :json => "ERROR: no currency"
    end
    
    begin
      currency = Currency.find(params[:currency])
    rescue
      return render :json => "ERROR: no valid currency type"
    end
    
    price = Price.new( :item => item, :price => params[:value], :currency => currency )
    
    if price.save
      render :json => "OK"
    else
      render :json => "ERROR: price wasn't saved"
    end
  end
end
