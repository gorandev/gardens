class PropertyValuesController < ApplicationController
  respond_to :json
  
  def index
    @pvalues = PropertyValue.all
    respond_with(@pvalues)
  end
  
  def show
    @pvalue = PropertyValue.find(params[:id])
    respond_with(@pvalue)
  end
  
  def create
    property_value = PropertyValue.new( :value => params[:value], :property => Property.find_by_id(params[:property]) )
    
    if property_value.save
      render :json => "OK"
    else
      if params.has_key?(:property)
        property_value.errors.add(:property, "must be valid")
      end
      render :json => { :errors => property_value.errors }, :status => 400
    end
  end
  
  def update
    unless property_value = PropertyValue.find_by_id(params[:id])
      return render :json => { :errors => { :property_value => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:value)
      property_value.value = params[:value]
    end
    
    if params.has_key?(:property)
      unless property = Property.find_by_id(params[:property])
        return render :json => { :errors => { :property => "must be valid" } }, :status => 400
      else
        property_value.property = property
      end
    end
    
    if property_value.attributes == PropertyValue.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :property_value => "nothing to update" } }
    end
    
    if property_value.save
      render :json => "OK"
    else
      render :json => { :errors => property_value.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:value, :property).empty?
      return render :json => { :errors => { :property_value => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:property)
      unless Property.find_by_id(params[:property])
        return render :json => { :errors => { :property => "not found" } }, :status => 400
      end
      params[:property_id] = params[:property]
    end
    
    respond_with(PropertyValue.where(params.slice(:value, :property_id)))
  end
  
  def destroy
    unless property_value = PropertyValue.find_by_id(params[:id])
      return render :json => { :errors => { :property_value => "must be valid" } }, :status => 400
    end
    property_value.destroy
    render :json => "OK"
  end
end