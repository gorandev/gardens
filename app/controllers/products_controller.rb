class ProductsController < ApplicationController
  respond_to :json
  
  def index
    @products = Product.all
    respond_with(@products)
  end
  
  def show
    @product = Product.find(params[:id])
    respond_with(@product)
  end
  
  def new
    @product = Product.new
    @product.property_values.build
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = 'Salvado con éxito'
      redirect_to :action => "new"
    else 
      render :action => "new"
    end
  end
end
