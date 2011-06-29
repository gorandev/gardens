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
      render :json => { :id => product_type.id }
    else
      render :json => { :errors => product_type.errors }, :status => 400
    end
  end
  
  def update
    unless product_type = ProductType.find_by_id(params[:id])
      return render :json => { :errors => { :id => "must be valid" } }, :status => 400
    end
        
    if params.has_key?(:name)
      product_type.name = params[:name]
    end
 
    if product_type.attributes == ProductType.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :product_type => "nothing to update" } }
    end
    
    if product_type.save
      render :json => "OK"
    else
      render :json => { :errors => product_type.errors }, :status => 400
    end
  end
  
  def destroy
    unless product_type = ProductType.find_by_id(params[:id])
      return render :json => { :errors => { :product_type => "must be valid" } }, :status => 400
    end
    product_type.destroy
    render :json => "OK"
  end
  
  def search    
    unless params.has_key?(:name)
      return render :json => { :errors => { :product_type => "no search parameters" } }, :status => 400
    end
    @product_types = ProductType.where(params.slice(:name))
    respond_with(@product_types)
  end
end
