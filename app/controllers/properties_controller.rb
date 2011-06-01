class PropertiesController < ApplicationController
  respond_to :json
  
  def get_by_product_type
    @properties = Property.where("product_type_id = ?", params[:id])
    respond_with(@properties)
  end
  
  def index
    @properties  = Property.all
    respond_with(@properties)
  end
  
  def show
    @property  = Property.find(params[:id])
    respond_with(@property)
  end
  
  def new
    @property = Property.new
  end
  
  def create
    if params.has_key?("property")
      return create_from_form
    end

    property = Property.new( :name => params[:name], :product_type => ProductType.find_by_id(params[:product_type]) )
    
    if property.save
      render :json => "OK"
    else
      render :json => { :errors => property.errors }
    end
  end
  
  def create_from_form
    @property = Property.new(params[:property])
    if @property.save
      flash[:notice] = 'Salvado con éxito'
      redirect_to :action => "new"
    else 
      render :action => "new"
    end
  end
end
