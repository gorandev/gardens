class ProductTypesController < ApplicationController
  respond_to :json
  
  def index
    @product_types = ProductType.all
    respond_with(@product_types)
  end
  
  def show
    @product_type = ProductType.find(params[:id])
    respond_with(@product_type)
  end
  
  def create
    product_type = ProductType.new( :name => params[:name] )
    
    if product_type.save
      render :json => "OK"
    else
      render :json => { :errors => product_type.errors }
    end
  end
end
