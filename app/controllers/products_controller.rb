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
    pvs = Array.new
    begin
      params[:property_values].each_index do |pv|
        begin
          pvs.push(PropertyValue.find(pv))
        rescue
        end
      end
    rescue
    end
    
    begin
      product_type = ProductType.find(params[:product_type])
      product = Product.new( :product_type => product_type )
      product.property_values << pvs
      
      if product.save
        render :json => 'OK'
      else
        render :json => 'ERROR I'
      end
      
    rescue
      render :json => 'ERROR II'
    end    

  end
  
  def create_from_form
    pvs = Array.new
    begin
      params[:product][:property_values].each_index do |pv|
        begin
          pvs.push(PropertyValue.find(params[:product][:property_values][pv]))
        rescue
        end
      end
    rescue
    end
    params[:product][:property_values] = pvs
    @product = Product.new(params[:product])
    @product.valid?
    unless pvs.length > 0
      if @product.errors.empty?
        @product.errors[:product_type] = "select at least one property value"
      end
      render :action => "new"
    else
      if @product.save
        flash[:notice] = "Salvado con éxito"
        redirect_to :action => "new"
      else 
        render :action => "new"
      end
    end
  end
end
