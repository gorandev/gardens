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
end
