class PropertyValuesController < ApplicationController
  def index
    resultado = Array.new
    PropertyValue.find_each do |pv|
      resultado.push(pv_para_json(pv))
    end
    
    render :json => resultado
  end

  def show
    begin
      pv = PropertyValue.find(params[:id])
    rescue
      return :json => "NOT FOUND"
    end

    render :json => pv_para_json(pv)
  end
  
  private
  
  def pv_para_json(pv)
    return { :id => pv.id, :value => pv.value, :property => pv.property.name, :product_type => pv.property.product_type.name }
  end
end
