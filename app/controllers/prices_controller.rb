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
      :price_date => params[:price_date],
      :currency => Currency.find_by_id(params[:currency])
    )
    
    if price.save
      render :json => { :id => price.id }
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
  
  def search    
    if params.slice(:item, :currency, :price_date).empty?
      return render :json => { :errors => { :price => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:item)
      if Item.find_by_id(params[:item])
        params[:item_id] = params[:item]
      else
        return render :json => { :errors => { :item => "not found" } }, :status => 400
      end
    end

    if params.has_key?(:currency)
      if Currency.find_by_id(params[:currency])
        params[:currency_id] = params[:currency]
      else
        return render :json => { :errors => { :currency => "not found" } }, :status => 400
      end
    end
    
    respond_with(Price.where(params.slice(:item_id, :currency_id, :price_date)))
  end
end
