class ProductTypesController < ApplicationController
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
