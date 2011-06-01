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
      render :json => { :errors => retailer.errors }
    end
  end
end
