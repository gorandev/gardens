class ProductTypesController < ApplicationController
  def show
    properties = Array.new
    ProductType.find(params[:id]).properties.find_each do |p| 
      line = Hash.new
      line[:name] = p.name
      line[:id] = p.id
      properties.push(line) 
    end
    render :json => properties
  end
end
