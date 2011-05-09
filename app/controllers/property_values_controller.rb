class PropertyValuesController < ApplicationController
  def show
    property_values = Hash.new
    property_values[:id] = params[:id]
    property_values[:value] = PropertyValue.find(params[:id]).value
    property_values[:product_type] = PropertyValue.find(params[:id]).property.product_type.name
    property_values[:property] = PropertyValue.find(params[:id]).property.name
    render :json => property_values
  end
end
