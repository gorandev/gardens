class PropertiesController < ApplicationController
  def index
    resultado = Array.new
    Property.find_each do |p|
      property_line = Hash.new
      property_line[:id] = p.id
      property_line[:name] = p.name
      property_line[:product_type] = p.product_type.name
      property_line[:possible_values] = Array.new
      p.property_values.find_each do |pv| 
        line = Hash.new
        line[:value] = pv.value
        line[:id] = pv.id
        property_line[:possible_values].push(line) 
      end
      resultado.push(property_line)
    end
    render :json => resultado
  end

  def show
    resultado = Hash.new
    resultado[:id] = params[:id]
    resultado[:name] = Property.find(params[:id]).name
    resultado[:product_type] = Property.find(params[:id]).product_type.name
    resultado[:possible_values] = Array.new
    Property.find(params[:id]).resultado.find_each do |pv| 
      line = Hash.new
      line[:value] = pv.value
      line[:id] = pv.id
      resultado[:possible_values].push(line) 
    end
    render :json => resultado
  end
end
