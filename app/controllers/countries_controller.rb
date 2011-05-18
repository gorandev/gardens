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
    if params.has_key?("country")
      return create_from_form
    end
   
    if !params.has_key?("name")
      return render :json => "ERROR: no name"
    end

    if !params.has_key?("iso_code")
      return render :json => "ERROR: no iso_code"
    end
    
    if !params.has_key?("locale")
      return render :json => "ERROR: no locale"
    end

    if !params.has_key?("time_zone")
      return render :json => "ERROR: no time_zone"
    end

    if !params.has_key?("currency")
      return render :json => "ERROR: no currency"
    end
    
    begin
      currency = Currency.find(params[:currency])
    rescue
      return render :json => "ERROR: no valid currency type"
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
      render :json => "ERROR: country wasn't saved"
    end
  end
end


# validates_presence_of :name, :iso_code, :locale, :time_zone, :currency