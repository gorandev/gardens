class TipoProductosController < ApplicationController
  def index
    @tp = TipoProducto.all
   
    respond_to do |format|
      format.xml  { render :xml => @tp }
    end
  end
end
