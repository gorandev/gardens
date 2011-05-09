class ProductTypesController < ApplicationController
  def index
    product_types = Array.new
    ProductType.find_each do |pt|
      product_line = Hash.new
      product_line[:id] = pt.id
      product_line[:name] = pt.name
      properties = Array.new
      pt.properties.find_each do |p| 
        line = Hash.new
        line[:name] = p.name
        line[:id] = p.id
        line[:possible_values] = Array.new
        p.property_values.each do |pv| 
          line_pv = Hash.new
          line_pv[:id] = pv.id
          line_pv[:value] = pv.value
          line[:possible_values].push(line_pv)
        end
        properties.push(line) 
      end
      product_line[:properties] = properties
      product_types.push(product_line)
     end
    render :json => product_types
  end
  
  def show
    properties = Array.new
    ProductType.find(params[:id]).properties.find_each do |p| 
      line = Hash.new
      line[:name] = p.name
      line[:id] = p.id
      line[:possible_values] = Array.new
      p.property_values.each do |pv| 
        line_pv = Hash.new
        line_pv[:id] = pv.id
        line_pv[:value] = pv.value
        line[:possible_values].push(line_pv)
      end
      properties.push(line) 
    end
    render :json => properties
  end
end
