class PropertyValuesController < ApplicationController
  def index
    resultado = Array.new
    PropertyValue.find_each do |pv|
      property_line = Hash.new
      property_line[:id] = pv.id
      property_line[:value] = pv.value
      property_line[:product_type] = pv.property.product_type.name
      property_line[:property] = pv.property.name
      resultado.push(property_line)
    end
    render :json => resultado
  end

  def show
    property_values = Hash.new
    property_values[:id] = params[:id]
    property_values[:value] = PropertyValue.find(params[:id]).value
    property_values[:product_type] = PropertyValue.find(params[:id]).property.product_type.name
    property_values[:property] = PropertyValue.find(params[:id]).property.name
    render :json => property_values
  end
end
