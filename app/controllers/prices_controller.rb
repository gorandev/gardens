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
    price = Price.new(
      :price => params[:value],
      :item => Item.find_by_id(params[:item]),
      :currency => Currency.find_by_id(params[:currency])
    )
    
    if price.save
      render :json => "OK"
    else
      render :json => { :errors => price.errors }
    end
  end
end
