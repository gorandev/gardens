class CountriesController < ApplicationController
  respond_to :json
  
  def index
    @countries = Country.all
    respond_with(@countries)
  end
  
  def show
    @country = Country.find(params[:id])
    respond_with(@country)
  end
  
  def create

    begin
      currency = Currency.find(params[:currency])
    rescue
    end
  
    country = Country.new( 
      :name => params[:name], 
      :iso_code => params[:iso_code], 
      :locale => params[:locale], 
      :time_zone => params[:time_zone], 
      :currency => currency
    )
    
    if country.save
      render :json => "OK"
    else
      render :json => { :errors => country.errors }
    end
  end
end
