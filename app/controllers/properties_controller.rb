class PropertiesController < ApplicationController
  def index
    resultado = Array.new
    Property.find_each do |p|
      resultado.push(p_para_json(p))
    end
    
    render :json => resultado
  end

  def show
    begin
      p = Property.find(params[:id])
    rescue
      return :json => "NOT FOUND"
    end

    render :json => p_para_json(p)
  end

  private
  
  def p_para_json(p)
    resultado = Hash.new
    resultado[:id] = p.id
    resultado[:name] = p.name
    resultado[:product_type] = p.product_type.name
    resultado[:possible_values] = Array.new
    p.property_values.find_each do |pv|
      resultado[:possible_values].push(pv_para_json(pv))
    end
    return resultado
  end
  
  def pv_para_json(pv)
    return { :id => pv.id, :value => pv.value }
  end
end
