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
    retailer = Retailer.new( :name => params[:name], :country => Country.find_by_id(params[:country]) )
    
    if retailer.save
      render :json => "OK"
    else
      if params.has_key?(:country)
        retailer.errors.add(:country, "must be valid")
      end
      render :json => { :errors => retailer.errors }, :status => 400
    end
  end
end
