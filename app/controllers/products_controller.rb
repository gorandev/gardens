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

    property_values = Array.new
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
      
      if property_values.size != pv_param_size
        property_values.clear
      end
    end
    
    product = Product.new( 
      :product_type => ProductType.find_by_id(params[:product_type]), 
      :property_values => property_values,
      :imagen_id => params[:imagen_id]
    )
    
    if product.save
      render :json => { :id => product.id }
    else
      if params.has_key?(:product_type) && product.product_type == nil
        product.errors.add(:product_type, "must be valid")
      end
      if params.has_key?(:property_values) && product.property_values.empty?
        product.errors.add(:property_values, "must be all valid")
      end
      render :json => { :errors => product.errors }, :status => 400
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
        flash[:notice] = "Salvado con exito"
        redirect_to :action => "new"
      else 
        render :action => "new"
      end
    end
  end
  
  def update
    unless product = Product.find_by_id(params[:id])
      return render :json => { :errors => { :product => "must be valid" } }, :status => 400
    end

    if params.has_key?(:product_type)
      unless product_type = ProductType.find_by_id(params[:product_type])
        return render :json => { :errors => { :product_type => "must be valid" } }, :status => 400
      end
      product.product_type = product_type
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
          product.property_values << property_values
        else
          product.property_values = property_values
        end
      end
    end
    
    if product.save
      render :json => "OK"
    else
      render :json => { :errors => product.errors }, :status => 400
    end
  end
  
  def destroy
    unless product = Product.find_by_id(params[:id])
      return render :json => { :errors => { :product => "must be valid" } }
    end
    
    product.destroy
    render :json => "OK"
  end
  
  def search    
    if params.slice(:product_type, :property_values).empty?
      return render :json => { :errors => { :product => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:product_type)
      if ProductType.find_by_id(params[:product_type])
        params[:product_type_id] = params[:product_type]
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

    @products = Product.joins(join).where(params.slice(:product_type_id, :property_values)).group(:id)
    respond_with(@products)
  end
  
  def prices 
    @pagina = 'Precios'
    @categorias = ProductType.all
    @retailers = Retailer.all
    
    @properties = Array.new
    for p in Property.where( :name => [ "marca", "marca_procesador", "modelo_procesador", "memoria", "disco", "pantalla", "os", "touch" ] )
      props = Array.new
      for pp in p.property_values
        props.push({
          :id => pp.id,
          :name => pp.value
        })
      end
      @properties.push({ :name => p.name, :props => props })
    end
    
    @products = Array.new
    for p in Product.all
      marca = p.property_values.index_by(&:property_id)[Property.find_by_name('marca').id].try(:value)
      modelo = p.property_values.index_by(&:property_id)[Property.find_by_name('modelo').id].try(:value)
      if marca.nil? || modelo.nil?
        next
      end
      @products.push({ 
        :id => p.id,
        :name => marca << ' ' << modelo
      })
    end
  end
end