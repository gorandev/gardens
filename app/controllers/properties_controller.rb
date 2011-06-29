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
      render :json => { :id => property.id }
    else
      if params.has_key?(:product_type)
        property.errors.add(:product_type, "must be valid")
      end
      render :json => { :errors => property.errors }, :status => 400
    end
  end
  
  def create_from_form
    @property = Property.new(params[:property])
    if @property.save
      flash[:notice] = 'Salvado con exito'
      redirect_to :action => "new"
    else 
      render :action => "new"
    end
  end
  
  def update
    unless property = Property.find_by_id(params[:id])
      return render :json => { :errors => { :property => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:name)
      property.name = params[:name]
    end
    
    if params.has_key?(:product_type)
      unless product_type = ProductType.find_by_id(params[:product_type])
        return render :json => { :errors => { :product_type => "must be valid" } }, :status => 400
      else
        property.product_type = product_type
      end
    end
    
    if property.attributes == Property.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :property => "nothing to update" } }
    end
    
    if property.save
      render :json => "OK"
    else
      render :json => { :errors => property.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:name, :product_type).empty?
      return render :json => { :errors => { :property => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:product_type)
      unless ProductType.find_by_id(params[:product_type])
        return render :json => { :errors => { :product_type => "not found" } }, :status => 400
      end
      params[:product_type_id] = params[:product_type]
    end

    @properties = Property.where(params.slice(:name, :product_type_id)) 
    respond_with(@properties)
  end
  
  def destroy
    unless property = Property.find_by_id(params[:id])
      return render :json => { :errors => { :property => "must be valid" } }, :status => 400
    end
    property.destroy
    render :json => "OK"
  end
end