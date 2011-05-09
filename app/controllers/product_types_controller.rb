class ProductTypesController < ApplicationController
  def show
    properties = Array.new
    ProductType.find(params[:id]).properties.find_each do |p| properties.push(p.name) end
    render :json => properties
  end
end
