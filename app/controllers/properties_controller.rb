class PropertiesController < ApplicationController
  def show
    property_values = Hash.new
    property_values[:id] = params[:id]
    property_values[:name] = Property.find(params[:id]).name
    property_values[:product_type] = Property.find(params[:id]).product_type.name
    property_values[:possible_values] = Array.new
    Property.find(params[:id]).property_values.find_each do |pv| 
      line = Hash.new
      line[:value] = pv.value
      line[:id] = pv.id
      property_values[:possible_values].push(line) 
    end
    render :json => property_values
  end
end
