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
    begin
      property = Property.find(params[:property])
    rescue
    end
    
    property_value = PropertyValue.new( :value => params[:value], :property => property )
    
    if property_value.save
      render :json => "OK"
    else
      render :json => { :errors => property_value.errors }
    end
  end
  
end
