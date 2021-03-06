require 'ostruct'
class PropertyValuesController < ApplicationController
  respond_to :json
  
  def index
    @property_values = PropertyValue.limit(@count).offset(@offset)
    respond_with(@property_values)
  end
  
  def show
    @property_value = PropertyValue.find(params[:id])
    respond_with(@property_value)
  end
  
  def create
    property_value = PropertyValue.new( :value => params[:value], :property => Property.find_by_id(params[:property]) )
    
    if property_value.save
      render :json => { :id => property_value.id }
    else
      if params.has_key?(:property)
        property_value.errors.add(:property, "must be valid")
      end
      render :json => { :errors => property_value.errors }, :status => 400
    end
  end
  
  def update
    unless property_value = PropertyValue.find_by_id(params[:id])
      return render :json => { :errors => { :property_value => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:value)
      property_value.value = params[:value]
    end
    
    if params.has_key?(:property)
      unless property = Property.find_by_id(params[:property])
        return render :json => { :errors => { :property => "must be valid" } }, :status => 400
      else
        property_value.property = property
      end
    end
    
    if property_value.attributes == PropertyValue.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :property_value => "nothing to update" } }
    end
    
    if property_value.save
      render :json => "OK"
    else
      render :json => { :errors => property_value.errors }, :status => 400
    end
  end
  
  def search    
    if params.has_key?(:products)
      return _search_fast
    end

    if params.slice(:value, :property, :product_type, :word, :id).empty?
      return render :json => { :errors => { :property_value => "no search parameters" } }, :status => 400
    end

    join = Array.new
    if params.has_key?(:property)
      unless Property.find_by_id(params[:property])
        return render :json => { :errors => { :property => "not found" } }, :status => 400
      end
      params[:properties] = { :id => params[:property] }
      join.push(:property)
    end
    
    if params.has_key?(:product_type)
      unless ProductType.find_by_id(params[:product_type])
        return render :json => { :errors => { :product_type => "not found" } }, :status => 400
      end
      
      if join.include?(:property)
        params[:properties][:product_type_id] = params[:product_type]
      else
        join.push(:property)
        params[:properties] = { :product_type_id => params[:product_type] }
      end
    end
    
    if params.has_key?(:id) and params[:id].is_a?String
        params[:id] = params[:id].split(',')
    end

    if params.has_key?(:word)
      join.push(:word)
      params[:words] = { :value => params[:word].upcase }
    end
    
    @property_values = PropertyValue.joins(join).where(params.slice(:value, :properties, :words, :id))
    respond_with(@property_values)
  end
  
  def destroy
    unless property_value = PropertyValue.find_by_id(params[:id])
      return render :json => { :errors => { :property_value => "must be valid" } }, :status => 400
    end
    property_value.destroy
    render :json => "OK"
  end

  private

  def _search_fast
    @property_values = Array.new
    REDIS.sunion(*params[:products].split(',').map {|x| "pvs_product:#{x}"}).each do |arr|
      data = arr.split('|')
      @property_values.push(OpenStruct.new({
        :id => data[0],
        :value => data[1],
        :descripcion_property => data[2]
      }))
    end
    render "search_fast"
  end
end