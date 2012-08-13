require 'ostruct'
class ProductsController < ApplicationController
  before_filter :authenticate_user!, :set_globales
  respond_to :json

  def index
    @products = Product.limit(@count).offset(@offset)
  end
  
  def pagina_producto
    @product = Product.find_by_id(params[:id])
    @pagina = 'Productos'

    @marcas = PropertyValue.find_all_by_id(REDIS.sinter "marcas_por_country:#{@country_id}", "marcas_por_product_type:#{@product_type_id}").sort! { |a, b| a.value <=> b.value }
  
    @properties = Array.new
    if !@product.nil?
      @product_type_id = @product.product_type.id
      Settings["product_type_#{@product_type_id}"]['pagina_producto'].each do |p|
        next if @product.property_values.find_by_property_id(Property.find_by_name_and_product_type_id(p["field"], @product_type_id).nil?)
        next if @product.property_values.find_by_property_id(Property.find_by_name_and_product_type_id(p["field"], @product_type_id).id).nil?

        value = @product.property_values.find_by_property_id(Property.find_by_name_and_product_type_id(p["field"], @product_type_id).id).value
        
        unless p["boolean"].nil?
          value = (
            @product.property_values.find_by_property_id(Property.find_by_name_and_product_type_id(p["field"], @product_type_id).id).value.to_i > 0 ? 
            'Si' : 'No'
          );
        end
        @properties.push({
          :name => p["name"],
          :value => value
        })
      end

      pv_similares_ids = Array.new
      @product.property_values.joins(:property).where(
        :properties => { :product_type_id => @product_type_id, :name => Settings["product_type_#{@product_type_id}"]['productos_similares'] }).each do |pv|
          pv_similares_ids.push("property_value:#{pv.id}")
      end

      @productos_similares = Product.find_all_by_id(REDIS.sinter(*pv_similares_ids, "country:#{@country_id}")).sort! { |a, b| a.descripcion <=> b.descripcion }

      @available_countries = Array.new
      @product.active_in_countries.each do |c|
        @available_countries.push(c.id)
      end

      @url_imagen_producto = Settings["product_type_#{@product_type_id}"]['url_imagen_producto']
      @dates = _get_dates(@product.id, @currency_id)
      @sales = @product.sales.where(:currency_id => @currency_id).order('sale_date DESC').limit(5)
    end
  end

  def show
    @product = Product.find(params[:id])
    if params.has_key?("show_urls") and params.has_key?("country")
      @urls = Array.new
      Item.joins(:retailer).where(:retailers => { :country_id => params[:country] }, :product_id => params[:id]).order('retailers.name ASC').each do |i|
        price = Price.where(:item_id => i.id).order("price_date DESC").limit(1)
        @urls.push(OpenStruct.new({
          :url => i.url,
          :retailer => i.retailer.name,
          :price => (price.empty?) ? nil : price.first.price
        }))
      end
      render "show_urls" and return
    end
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
  
  def search_productizador
    if params.slice(:property_values, :country).empty?
      return render :json => { :errors => { :product => "no search parameters" } }, :status => 400
    end

    product_ids = Array.new

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

      params[:property_values].each do |pv|
        tmp_product_ids = REDIS.smembers('property_value:' + pv.to_s)
        next unless tmp_product_ids.is_a?Array
        unless product_ids.empty?
          product_ids = product_ids | tmp_product_ids
        else
          product_ids = tmp_product_ids
        end
      end
    end

    if params.has_key?(:country)
      unless Country.find_by_id(params[:country])
        return render :json => { :errors => { :country => "not found" } }, :status => 400
      end

      unless product_ids.empty?
        product_ids = product_ids & REDIS.smembers('country:' + params[:country].to_s)
      else
        product_ids = REDIS.smembers('country:' + params[:country].to_s)
      end
    end

    if params.has_key?(:marca)
      tmp_product_ids = REDIS.smembers('property_value:' + params[:marca])
      if tmp_product_ids.is_a?Array
        product_ids = product_ids & tmp_product_ids
      end
    end

    if params.has_key?(:retailer)
      tmp_product_ids = REDIS.smembers('retailer:' + params[:retailer])
      if tmp_product_ids.is_a?Array
        product_ids = product_ids & tmp_product_ids
      end
    end

    products_scores = Hash.new
    product_ids.each do |p|
      products_scores[p] = 0
      params[:property_values].each do |pv|
        if REDIS.sismember('property_value:' + pv.to_s, p)
          if params[:marca] == pv or params[:modelo] == pv
            products_scores[p] += 3
          else
            products_scores[p] += 1
          end
        end
      end
    end

    products_scores.each do |k, v|
      unless v > 6
        product_ids.delete(k)
      end
    end

    if product_ids.empty?
      return
    end

    Product.class
    ProductType.class
    Item.class
    Country.class
    Retailer.class
    PropertyValue.class
    Property.class

    @products = Array.new
    product_ids.each do |id|
      next unless p = Product.find_by_id(id)

      pr = Price.joins(:item).where(:currency_id => Country.find_by_id(params[:country]).currency.id, :items => {:product_id => p} ).order(:price_date).last
      unless pr.nil?
        pr = pr.price
      end

      @products.push(OpenStruct.new({
        :id => id,
        :descripcion => p.descripcion,
        :imagen_id => p.imagen_id,
        :ultimo_precio_registrado => pr
      }))
    end
  end

  def search    
    if params.slice(:product_type, :property_values, :retailers, :country).empty?
      return render :json => { :errors => { :product => "no search parameters" } }, :status => 400
    end

    product_ids = Array.new
    if params.has_key?(:country)
      unless Country.find_by_id(params[:country])
        return render :json => { :errors => { :country => "not found" } }, :status => 400
      end

      unless product_ids.empty?
        product_ids = product_ids & REDIS.smembers('country:' + params[:country].to_s)
      else
        product_ids = REDIS.smembers('country:' + params[:country].to_s)
      end
    end
    
    if params.has_key?(:product_type)
      if params[:product_type].is_a?String
        unless params[:product_type].split(',').size > 0 && ProductType.find_all_by_id(params[:product_type].split(',')).size == params[:product_type].split(',').size
          return render :json => { :errors => { :product_type => "not found" } }, :status => 400
        end
        params[:product_type] = params[:product_type].split(',')
      elsif params[:product_type].is_a?Array
        unless params[:product_type].size > 0 && ProductType.find_all_by_id(params[:product_type]).size == params[:product_type].size
          return render :json => { :errors => { :product_type => "not found" } }, :status => 400
        end
      else
        return render :json => { :errors => { :property_values => "must be comma-separated string or JSON array" } }, :status => 400
      end

      product_types = Array.new
      params[:product_type].each do |p|
        product_types.push('product_type:' + p.to_s)
      end

      unless product_ids.empty?
        product_ids = product_ids & REDIS.sunion(*product_types)
      else
        product_ids = REDIS.sunion(*product_types)
      end
    end
    
    if params.has_key?(:retailers)
      if params[:retailers].is_a?String
        unless params[:retailers].split(',').size > 0 && Retailer.find_all_by_id(params[:retailers].split(',')).size == params[:retailers].split(',').size
          return render :json => { :errors => { :retailers => "not found" } }, :status => 400
        end
        params[:retailers] = params[:retailers].split(',')
      elsif params[:retailers].is_a?Array
        unless params[:retailers].size > 0 && Retailer.find_all_by_id(params[:retailers]).size == params[:retailers].size
          return render :json => { :errors => { :retailers => "not found" } }, :status => 400
        end
      else
        return render :json => { :errors => { :property_values => "must be comma-separated string or JSON array" } }, :status => 400
      end

      retailers = Array.new
      params[:retailers].each do |r|
        retailers.push('retailer:' + r.to_s)
      end

      unless product_ids.empty?
        product_ids = product_ids & REDIS.sunion(*retailers)
      else
        product_ids = REDIS.sunion(*retailers)
      end
    end

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

      properties = Hash.new
      params[:property_values].each do |pv|
        pname = PropertyValue.find(pv).property.name
        unless properties.has_key?(pname)
          properties[pname] = Array.new
        end
        properties[pname].push('property_value:' + pv)
      end

      properties.keys.each do |p|
        tmp_product_ids = REDIS.sunion(*properties[p])
        if tmp_product_ids and product_ids
            product_ids = product_ids & tmp_product_ids
        end
      end
    end

    if product_ids.empty?
      @products = Product.all(
        :include => [
          :product_type,
          { :items => { :retailer => :country } },
          { :property_values => :property }
        ]
      )
    else

      if params.has_key?(:fast)
        return _search_fast(product_ids)
      end

      Product.class
      ProductType.class
      Item.class
      Country.class
      Retailer.class
      PropertyValue.class
      Property.class

      @products = Array.new
      product_ids.each do |id|
        @products.push(Marshal.load(REDIS.get 'obj.product:' + id.to_s))
      end
    end
  end
  
  def prices 
    @pagina = 'Precios'

    @properties = Array.new
    Settings['product_type_' + @product_type_id.to_s]['precios'].each do |p|
      @properties.push({
        :name => p["name"],
        :field => p["field"],
        :id => Property.find_by_name(p["field"]).id
      })
    end
  end

  def get_dates
    dates = _get_dates(params[:product], @currency_id)
    @fechas = OpenStruct.new({
      :date_from => dates[0],
      :date_to => dates[1]
    })
  end

  def inicializar_memstore
    REDIS.flushall

    marcas_por_country = Hash.new
    marcas_por_product_type = Hash.new
    Product.all.each do |p|
      REDIS.set "obj.product:#{p.id}", Marshal.dump(p)
      REDIS.sadd "descripcion.product:#{p.id}", "#{p.id}|#{p.descripcion}"
      REDIS.sadd "product_type:#{p.product_type.id}", p.id

      unless marcas_por_product_type.has_key?(p.product_type.id)
        marcas_por_product_type[p.product_type.id] = Hash.new
      end
      marcas_por_product_type[p.product_type.id][p.property_values.joins(:property).where(:properties => { :name => 'marca' }).first.id] = 1;

      p.active_in_countries.each do |c|
        REDIS.sadd "country:#{c.id}", p.id
        unless marcas_por_country.has_key?(c.id)
          marcas_por_country[c.id] = Hash.new
        end
        marcas_por_country[c.id][p.property_values.joins(:property).where(:properties => { :name => 'marca' }).first.id] = 1;
      end
      p.active_in_retailers.each do |r|
        REDIS.sadd "retailer:#{r.id}", p.id
        REDIS.sadd "retailers.product:#{p.id}", r.id
      end
      p.property_values.all.each do |pv|
        REDIS.sadd "property_value:#{pv.id}", p.id
        REDIS.sadd "pvs_product:#{p.id}", "#{pv.id}|#{pv.value}|#{pv.property.name}"
      end
    end

    marcas_por_product_type.keys.each do |pt|
      marcas_por_product_type[pt].keys.each do |m|
        REDIS.sadd "marcas_por_product_type:#{pt}", m
      end
    end

    marcas_por_country.keys.each do |c|
      marcas_por_country[c].keys.each do |m|
        REDIS.sadd "marcas_por_country:#{c}", m
      end
    end

    Retailer.all.each do |r|
      REDIS.set "descripcion.retailer:#{r.id}", r.name
      REDIS.sadd "retailers_country:#{r.country.id}", r.id
    end

    Sale.all.each do |s|
      REDIS.sadd "producto_sale:#{s.product.id}", s.id
    end

    render :nothing => true
  end

  def categorias
    @pagina = 'Categorias'
  end

  def get_avg_prices
    query_sql = <<'SQL'
SELECT 
  r.id AS id, 
  r.name AS name, 
  r.country_id AS country_id, 
  r.created_at AS created_at, 
  r.updated_at AS updated_at, 
  r.color AS color, 
  AVG(pr.price) AS average_price, 
  pr.price_date AS price_date, 
  pv.id AS property_value_id,
  pv.value AS property_value_value,
  pv2.id AS property_value_2_id,
  pv2.value AS property_value_2_value
FROM prices pr
LEFT OUTER JOIN items i ON i.id = pr.item_id
LEFT OUTER JOIN retailers r ON r.id = i.retailer_id
LEFT OUTER JOIN countries c ON c.id = r.country_id
LEFT OUTER JOIN products p ON p.id = i.product_id
LEFT OUTER JOIN products_property_values ppv ON ppv.product_id = p.id
LEFT OUTER JOIN property_values pv ON pv.id = ppv.property_value_id
LEFT OUTER JOIN products_property_values ppv2 ON ppv2.product_id = p.id
LEFT OUTER JOIN property_values pv2 ON pv2.id = ppv2.property_value_id
WHERE c.id = ? AND pv.property_id = ? AND pv2.property_id = ?
SQL
    query_params = [ session[:country_id], 1, 4 ]

    if params.has_key?(:fecha_desde)
      query_sql += ' AND pr.price_date >= ? '
      query_params.push(params[:fecha_desde])
    end

    if params.has_key?(:fecha_hasta)
      query_sql += ' AND pr.price_date <= ? '
      query_params.push(params[:fecha_hasta])
    end

    if params.has_key?(:categoria)
      query_sql += " AND pv.id IN (#{params[:categoria]}) "
    end
    if params.has_key?(:marca)
      query_sql += " AND pv2.id IN (#{params[:marca]}) "
    end

    if params.has_key?(:retailer)
      query_sql += " AND r.id IN (#{params[:retailer]}) "
    end

    query_sql += <<'SQL'
GROUP BY 
  pr.price_date, 
  r.id, r.name, r.country_id, r.created_at, r.updated_at, r.color, 
  pv.id, pv.value,
  pv2.id, pv2.value
ORDER BY pr.price_date
SQL
    @avgs = Array.new
    avgs = Retailer.find_by_sql([query_sql, *query_params]).each do |p|
      @avgs.push(OpenStruct.new({
        :x => p.price_date.to_time.to_i * 1000,
        :y => p.average_price.to_f.round,
        :retailer_name => p.name,
        :property_value_name => p.property_value_value,
        :property_value_2_name => p.property_value_2_value
      }))
    end
  end

  def vendors
    @pagina = 'Vendors'
  end

  def retailers
    @pagina = 'Retailers'
  end

  def create_productizador
    if params.slice(:item, :property_values, :product_type).empty?
      render :json => { :errors => { :product => "parameters missing" } }, :status => 400 and return
    end

    property_values = Array.new
    params[:property_values].split(',').each do |pv|
      if (m = /^(.+)\|(.+)$/.match(pv))
        ppv = PropertyValue.new(
          :value => m[1],
          :property => Property.find_by_id(m[2])
        )
        ppv.save
        property_values.push(ppv)
      else
        if (ppv = PropertyValue.find_by_id(pv))
          property_values.push(ppv)
        end
      end
    end

    product = Product.new(
      :product_type => ProductType.find_by_id(params[:product_type]),
      :property_values => property_values
    )
    product.save

    if item = Item.find_by_id(params[:item])
      item.product = product
      item.save
    else
      item = create_item({
        :property_values => product.property_values.collect { |pv| pv.id },
        :product => product.id,
        :retailer => params[:retailer],
        :product_type => params[:product_type],
        :source => 'papel',
        :description => product.descripcion
      })
    end

    agregar_producto_a_memstore(product)

    @product = OpenStruct.new({:id => product.id})
  end

  def set_aws_filename
    unless current_user and current_user.administrator
      return render :json => { :errors => { :user => "not admin" } }, :status => 400
    end

    unless product = Product.find_by_id(params[:id])
      return render :json => { :errors => { :product => "must be valid" } }, :status => 400
    end

    if params.has_key?(:aws_filename)
      product.aws_filename = params[:aws_filename]
      product.save
    else
      return render :json => { :errors => { :aws_filename => "must exist" } }, :status => 400
    end

    render :json => { :id => product.id }, :callback => params[:callback]
  end

  private

  def _get_dates(product_ids, currency)
    unless product_ids.is_a?Array
      product_ids = product_ids.to_s.split(',')
    end

    date_last = Price.joins(:item => :product).where(:currency_id => currency, :products => { :id => product_ids }).order("prices.created_at DESC").limit(1).first
    date_first = Price.joins(:item => :product).where(:currency_id => currency, :products => { :id => product_ids }).order("prices.created_at ASC").limit(1).first

    unless date_first.nil?
      date_first = date_first.price_date
    end
    unless date_last.nil?
      date_last = date_last.price_date
    end

    return [ date_first, date_last ]
  end

  def _search_fast(ids)
    @products = Array.new
    REDIS.sunion(*ids.map{|x| "descripcion.product:#{x}"}).each do |arr|
      data = arr.split('|')
      @products.push(OpenStruct.new({
        :id => data[0],
        :value => data[1]
      }))
    end
    render "search_fast"
  end

  def agregar_producto_a_memstore(p)
    marcas_por_country = Hash.new
    marcas_por_product_type = Hash.new

    REDIS.set "obj.product:#{p.id}", Marshal.dump(p)
    REDIS.sadd "descripcion.product:#{p.id}", "#{p.id}|#{p.descripcion}"
    REDIS.sadd "product_type:#{p.product_type.id}", p.id

    unless marcas_por_product_type.has_key?(p.product_type.id)
      marcas_por_product_type[p.product_type.id] = Hash.new
    end
    marcas_por_product_type[p.product_type.id][p.property_values.joins(:property).where(:properties => { :name => 'marca' }).first.id] = 1;

    p.active_in_countries.each do |c|
      REDIS.sadd "country:#{c.id}", p.id
      unless marcas_por_country.has_key?(c.id)
        marcas_por_country[c.id] = Hash.new
      end
      marcas_por_country[c.id][p.property_values.joins(:property).where(:properties => { :name => 'marca' }).first.id] = 1;
    end
    p.active_in_retailers.each do |r|
      REDIS.sadd "retailer:#{r.id}", p.id
      REDIS.sadd "retailers.product:#{p.id}", r.id
    end
    p.property_values.all.each do |pv|
      REDIS.sadd "property_value:#{pv.id}", p.id
      REDIS.sadd "pvs_product:#{p.id}", "#{pv.id}|#{pv.value}|#{pv.property.name}"
    end

    marcas_por_product_type.keys.each do |pt|
      marcas_por_product_type[pt].keys.each do |m|
        REDIS.sadd "marcas_por_product_type:#{pt}", m
      end
    end

    marcas_por_country.keys.each do |c|
      marcas_por_country[c].keys.each do |m|
        REDIS.sadd "marcas_por_country:#{c}", m
      end
    end
  end
end