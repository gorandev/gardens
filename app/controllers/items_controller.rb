class ItemsController < ApplicationController
  respond_to :json
  
  def index
    @items = Item.limit(@count).offset(@offset)
    respond_with(@items)
  end
  
  def show
    @item = Item.find(params[:id])
    respond_with(@item)
  end

  def create
    item = create_item(params)
    
    unless item.is_a?Item
      return item
    end
    
    if item.errors.empty?
      render :json => { :id => item.id }
    else
      render :json => { :errors => item.errors }, :status => 400
    end
  end
  
  def update
    unless item = Item.find_by_id(params[:id])
      return render :json => { :errors => { :id => "must be valid" } }, :status => 400
    end

    if params.has_key?(:retailer) 
      unless retailer = Retailer.find_by_id(params[:retailer])
        return render :json => { :errors => { :retailer => "must be valid" } }, :status => 400
      end
      item.retailer = retailer
    end

    if params.has_key?(:product_type) 
      unless product_type = ProductType.find_by_id(params[:product_type])
        return render :json => { :errors => { :product_type => "must be valid" } }, :status => 400
      end
      item.product_type = product_type
    end
    
    if params.has_key?(:product)
      unless product = Product.find_by_id(params[:product])
        return render :json => { :errors => { :product => "must be valid" } }, :status => 400
      end
      item.product = product
    end

    if params.has_key?(:source)
      item.source = params[:source]
    end
    
    if params.has_key?(:url)
      item.url = params[:url]
    end
    
    if params.has_key?(:description)
      item.description = params[:description]
    end
    
    if params.has_key?(:property_values)
      if params[:property_values].is_a?String
        property_values = PropertyValue.find_all_by_id(params[:property_values].split(','))
        pv_param_size = params[:property_values].split(',').size
      else
        if params[:property_values].is_a?Array
          pv_param_size = params[:property_values].size
        end
        property_values = PropertyValue.find_all_by_id(params[:property_values])
      end
      
      if property_values.empty? || property_values.size != pv_param_size
        return render :json => { :errors => { :property_values => "must be all valid" } }, :status => 400
      else
        if params[:property_values].is_a?String
          item.property_values << property_values
        else
          item.property_values = property_values
        end
      end
    end
    
    if item.save
      render :json => "OK"
    else
      render :json => { :errors => item.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:retailer, :product, :product_type, :property_values, :source, :url).empty?
      return render :json => { :errors => { :item => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:retailer)
      if Retailer.find_by_id(params[:retailer])
        params[:retailer_id] = params[:retailer]
      else
        return render :json => { :errors => { :retailer => "not found" } }, :status => 400
      end
    end

    if params.has_key?(:product)
      if Product.find_by_id(params[:product])
        params[:product_id] = params[:product]
      else
        return render :json => { :errors => { :product => "not found" } }, :status => 400
      end
    end

    if params.has_key?(:product_type)
      if ProductType.find_by_id(params[:product_type])
        params[:product_type_id] = params[:product]
      else
        return render :json => { :errors => { :product_type => "not found" } }, :status => 400
      end
    end
    
    join = Array.new
    if params.has_key?(:property_values)
      if params[:property_values].is_a?String
        unless params[:property_values].split(',').size > 0 && PropertyValue.find_all_by_id(params[:property_values].split(',')).size == params[:property_values].split(',').size
          return render :json => { :errors => { :property_values => "not found" } }, :status => 400
        end
        params[:property_values] = params[:property_values].split(',')
      elsif params[:property_values].is_a?Array
        unless params[:property_values].size > 0 && PropertyValue.find_all_by_id(params[:property_values]).size == params[:property_values].size
          return render :json => { :errors => { :property_values => "not found" } }, :status => 400
        end
      else
        return render :json => { :errors => { :property_values => "must be comma-separated string or JSON array" } }, :status => 400
      end
      
      params[:property_values] = { :id => params[:property_values] }
      join.push(:property_values)
    end

    @items = Item.joins(join).where(params.slice(:retailer_id, :product_id, :product_type_id, :property_values, :source, :url)).group(:id).limit(@count).offset(@offset)
    respond_with(@items)
  end
  
  def destroy
    unless item = Item.find_by_id(params[:id])
      return render :json => { :errors => { :item => "must be valid" } }, :status => 400
    end
    item.destroy
    render :json => "OK"
  end
end