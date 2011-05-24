class ProductsController < ApplicationController
  respond_to :json
  
  def index
    @products = Product.all
    respond_with(@products)
  end
  
  def show
    @product = Product.find(params[:id])
    respond_with(@product)
  end
  
  def new
    @product = Product.new
    @product.property_values.build
  end

  def create
    if params.has_key?("product")
      return create_from_form
    end
    
    if !params.has_key?("product_type")
      return render :json => "ERROR: no product type"
    end
    
    begin
      product_type = ProductType.find(params[:product_type])
    rescue
      return render :json => "ERROR: no valid product type"
    end
    
    if !params.has_key?("property_values")
      return render :json => "ERROR: no property values"
    end
    
    pvs = Array.new
    params[:property_values].split(",").each do |pv|
      begin
        pvs.push(PropertyValue.find(pv))
      rescue
      end
    end
    
    if pvs.empty?
      return render :json => "ERROR: no valid property values"
    end
    
    product = Product.new( :product_type => product_type )
    product.property_values << pvs
    
    if product.save
      render :json => "OK"
    else
      render :json => "ERROR: product wasn't saved"
    end
  end
  
  def create_from_form
    pvs = Array.new
    begin
      params[:product][:property_values].each_index do |pv|
        begin
          pvs.push(PropertyValue.find(params[:product][:property_values][pv]))
        rescue
        end
      end
    rescue
    end
    params[:product][:property_values] = pvs
    @product = Product.new(params[:product])
    @product.valid?
    unless pvs.length > 0
      if @product.errors.empty?
        @product.errors[:product_type] = "select at least one property value"
      end
      render :action => "new"
    else
      if @product.save
        flash[:notice] = "Salvado con éxito"
        redirect_to :action => "new"
      else 
        render :action => "new"
      end
    end
  end
  
  def search
    valid_parameters = ['country', 'product_type', 'retailer']
    search_parameters = Hash.new
    valid_parameters.each do |p|
      if params.has_key?(p.to_sym)
        search_parameters[p] = params[p.to_sym]
      end
    end
    
    if search_parameters.empty?
      return render :json => "ERROR -- no parameters"
    end
    
    join = Array.new
    where = Hash.new
    
    if search_parameters.has_key?('product_type')
      where[:product_type_id] = search_parameters['product_type']
    end
    
    if search_parameters.has_key?('country')
      join.push(:retailers)
      where[:retailers] = { :country_id => search_parameters['country'] }
    end
    
    if search_parameters.has_key?('retailer')
      join.push(:items)
      where[:items] = { :retailer_id => search_parameters['retailer'] }
    end

    @products = Product.joins(join).where(where)
    respond_with(@products)
  end
end
