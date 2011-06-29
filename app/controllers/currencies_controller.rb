class CurrenciesController < ApplicationController
  respond_to :json
  
  def index
    @currencies = Currency.all
    respond_with(@currencies)
  end
  
  def show
    @currency = Currency.find(params[:id])
    respond_with(@currency)
  end
  
  def create
    currency = Currency.new( 
      :name => params[:name], 
      :symbol => params[:symbol]
    )
    
    if currency.save
      render :json => { :id => currency.id }
    else
      render :json => { :errors => currency.errors }, :status => 400
    end
  end
  
  def update
    unless currency = Currency.find_by_id(params[:id])
      return render :json => { :errors => { :id => "must be valid" } }, :status => 400
    end
    
    [ "name", "symbol" ].each { |a|
      if params.has_key?(a)
        currency[a] = params[a]
      end
    }
    
    if currency.attributes == Currency.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :currency => "nothing to update" } }
    end
    
    if currency.save
      render :json => "OK"
    else
      render :json => { :errors => currency.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:name, :symbol).empty?
      return render :json => { :errors => { :currency => "no search parameters" } }, :status => 400
    end

    @currencies = Currency.where(params.slice(:name, :symbol))
    respond_with(@currencies)
  end
  
  def destroy
    unless currency = Currency.find_by_id(params[:id])
      return render :json => { :errors => { :currency => "must be valid" } }, :status => 400
    end
    currency.destroy
    render :json => "OK"
  end
end
