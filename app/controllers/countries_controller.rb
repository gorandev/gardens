class CountriesController < ApplicationController
  def index
    resultado = Array.new
    Country.find_each do |c|
      resultado.push(c_para_json(c))
    end
    
    render :json => resultado
  end
  
  def show
    begin
      c = Country.find(params[:id])
    rescue
      render :json => "ERROR"
      return false
    end
    
    render :json => c_para_json(c)
  end
  
  private
  
  def c_para_json(c)
    return { :id => c.id, :name => c.name }
  end
end
