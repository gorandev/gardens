class RetailersController < ApplicationController
  respond_to :json
  
  def index
    @retailers = Retailer.all
    respond_with(@retailers)
  end
  
  def show
    @Retailer = Retailer.find(params[:id])
    respond_with(@Retailer)
  end
  
  def create
    if params.has_key?("retailer")
      return create_from_form
    end
   
    if !params.has_key?("name")
      return render :json => "ERROR: no name"
    end

    if !params.has_key?("country")
      return render :json => "ERROR: no country"
    end
    
    begin
      country = Country.find(params[:country])
    rescue
      return render :json => "ERROR: no valid country"
    end
    
    retailer = Retailer.new( :name => params[:name], :country => country )
    
    if retailer.save
      render :json => "OK"
    else
      render :json => "ERROR: retailer wasn't saved"
    end
  end
end
