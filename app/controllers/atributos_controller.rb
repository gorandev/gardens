class AtributosController < ApplicationController
  def index
    @a = Atributo.all
   
    respond_to do |format|
      format.xml
    end
  end
  
  def show
    @a = Atributo.find(params[:id])
    respond_to do |format|
      format.xml
    end
  end
end
