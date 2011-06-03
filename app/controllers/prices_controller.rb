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
      if params.has_key?(:item) && price.item == nil
        price.errors.add(:item, "must be valid")
      end
      if params.has_key?(:currency) && price.currency == nil
        price.errors.add(:currency, "must be valid")
      end
      render :json => { :errors => price.errors }, :status => 400
    end
  end
end
