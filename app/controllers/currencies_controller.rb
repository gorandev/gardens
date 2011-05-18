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
    if params.has_key?("currency")
      return create_from_form
    end
   
    if !params.has_key?("name")
      return render :json => "ERROR: no name"
    end

    if !params.has_key?("symbol")
      return render :json => "ERROR: no symbol"
    end
        
    currency = Currency.new( 
      :name => params[:name], 
      :symbol => params[:symbol]
    )
    
    if currency.save
      render :json => "OK"
    else
      render :json => "ERROR: currency wasn't saved"
    end
  end
end
