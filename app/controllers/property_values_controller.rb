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
    if params.has_key?("property_value")
      return create_from_form
    end
   
    if !params.has_key?("value")
      return render :json => "ERROR: no value"
    end
   
    if !params.has_key?("property")
      return render :json => "ERROR: no property"
    end
    
    begin
      property = Property.find(params[:property])
    rescue
      return render :json => "ERROR: no valid property"
    end
    
    property_value = PropertyValue.new( :value => params[:value], :property => property )
    
    if property_value.save
      render :json => "OK"
    else
      render :json => "ERROR: property value wasn't saved"
    end
  end
  
end
