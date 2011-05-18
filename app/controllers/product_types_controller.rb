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
    if params.has_key?("product_type")
      return create_from_form
    end
   
    if !params.has_key?("name")
      return render :json => "ERROR: no name"
    end
   
    product_type = ProductType.new( :name => params[:name] )
    
    if product_type.save
      render :json => "OK"
    else
      render :json => "ERROR: product type wasn't saved"
    end
  end
end
