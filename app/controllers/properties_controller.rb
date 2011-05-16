class PropertiesController < ApplicationController
  respond_to :json
  
  def index
    @properties  = Property.all
    respond_with(@properties)
  end
  
  def show
    @property  = Property.find(params[:id])
    respond_with(@property)
  end
end
