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
end
