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
    country = Country.new( 
      :name => params[:name], 
      :iso_code => params[:iso_code], 
      :locale => params[:locale], 
      :time_zone => params[:time_zone], 
      :currency => Currency.find_by_id(params[:currency])
    )
    
    if country.save
      render :json => "OK"
    else
      if params.has_key?(:currency) && country.currency == nil
        country.errors.add(:currency, "must be valid")
      end
      render :json => { :errors => country.errors }, :status => 400
    end
  end
end
