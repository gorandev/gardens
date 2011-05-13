class ProductsController < ApplicationController
  def index
    resultado = Array.new
    Product.find_each do |p|
      resultado.push(p_para_json(p))
    end
    
    render :json => resultado
  end

  def show
    begin
      p = Product.find(params[:id])
    rescue
      render :json => "ERROR"
      return false
    end
    
    render :json => p_para_json(p)
  end
  
  private
  
  def p_para_json(p)
    return { :id => p.id, :product_type => p.product_type.name, :property_values => pp_para_json(p.property_values) }
  end
  
  def pp_para_json(pp)
    resultado = Array.new
    pp.find_each do |pp|
      line = Hash.new
      line[:name] = pp.property.name
      line[:value] = pp.value
      resultado.push(line)
    end
    return resultado
  end
end
