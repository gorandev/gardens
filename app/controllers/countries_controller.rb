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
      render :json => { :id => country.id }
    else
      if params.has_key?(:currency) && country.currency == nil
        country.errors.add(:currency, "must be valid")
      end
      render :json => { :errors => country.errors }, :status => 400
    end
  end
  
  def update
    unless country = Country.find_by_id(params[:id])
      return render :json => { :errors => { :id => "must be valid" } }, :status => 400
    end
    
    [ "name", "iso_code", "locale", "time_zone" ].each { |a|
      if params.has_key?(a)
        country[a] = params[a]
      end
    }
    
    if params.has_key?(:currency)
      unless currency = Currency.find_by_id(params[:currency])
        return render :json => { :errors => { :currency => "must be valid" } }, :status => 400
      else
        country.currency = currency
      end
    end
    
    if country.attributes == Country.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :country => "nothing to update" } }
    end
    
    if country.save
      render :json => "OK"
    else
      render :json => { :errors => country.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:name, :iso_code, :locale, :time_zone, :currency, :currency_id).empty?
      return render :json => { :errors => { :country => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:currency)
      if Currency.find_by_name(params[:currency])
        params[:currency_id] = Currency.find_by_name(params[:currency]).id
      else
        return render :json => { :errors => { :currency => "not found" } }, :status => 400
      end
    end
    
    if params.has_key?(:currency_id) && !Currency.find_by_id(params[:currency_id])
      return render :json => { :errors => { :currency => "not found" } }, :status => 400
    end
   
    @countries = Country.where(params.slice(:name, :iso_code, :locale, :time_zone, :currency_id))
    respond_with(@countries)
  end

  def destroy
    unless country = Country.find_by_id(params[:id])
      return render :json => { :errors => { :country => "must be valid" } }, :status => 400
    end
    country.destroy
    render :json => "OK"
  end
end