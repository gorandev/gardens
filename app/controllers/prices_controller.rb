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
    begin
      item = Item.find(params[:item])
    rescue
    end
    
    begin
      currency = Currency.find(params[:currency])
    rescue
    end
    
    price = Price.new( :item => item, :price => params[:value], :currency => currency )
    
    if price.save
      render :json => "OK"
    else
      render :json => { :errors => price.errors }
    end
  end
end
