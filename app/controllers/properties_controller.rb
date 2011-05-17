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
  
  def new
    @property = Property.new
  end
  
  def create
    @property = Property.new(params[:property])
    if @property.save
      flash[:notice] = 'Salvado con éxito'
      redirect_to :action => "new"
    else 
      render :action => "new"
    end
  end
end
