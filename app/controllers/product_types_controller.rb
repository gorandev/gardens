class ProductTypesController < ApplicationController
  def index
    resultado = Array.new
    ProductType.find_each do |pt|
      resultado.push(pt_para_json(pt))
    end
    
    render :json => resultado
  end
  
  def show
    begin
      pt = ProductType.find(params[:id])
    rescue
      render :json => "ERROR"
      return false
    end
    
    render :json => pt_para_json(pt)
  end
  
  private
  
  def pt_para_json(pt)
      resultado = Hash.new
      resultado[:name] = pt.name
      resultado[:id] = pt.id
      resultado[:properties] = Array.new
      pt.properties.find_each do |p|
        resultado[:properties].push(p_para_json(p))
      end
      return resultado
  end
  
  def p_para_json(p)
    resultado = Hash.new
    resultado[:id] = p.id
    resultado[:name] = p.name
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
