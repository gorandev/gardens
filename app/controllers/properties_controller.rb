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
   
    if !params.has_key?("name")
      return render :json => "ERROR: no name"
    end
   
    if !params.has_key?("product_type")
      return render :json => "ERROR: no product type"
    end
    
    begin
      product_type = ProductType.find(params[:product_type])
    rescue
      return render :json => "ERROR: no valid product type"
    end
    
    property = Property.new( :name => params[:name], :product_type => product_type )
    
    if property.save
      render :json => "OK"
    else
      render :json => "ERROR: property wasn't saved"
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
