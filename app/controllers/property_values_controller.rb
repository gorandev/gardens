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
  
end
