class CurrenciesController < ApplicationController
  respond_to :json
  
  def index
    @currencies = Currency.all
    respond_with(@currencies)
  end
  
  def show
    @Currency = Currency.find(params[:id])
    respond_with(@Currency)
  end
  
  def create

    currency = Currency.new( 
      :name => params[:name], 
      :symbol => params[:symbol]
    )
    
    if currency.save
      render :json => "OK"
    else
      render :json => { :errors => currency.errors }
    end
  end
end
