class PricesController < ApplicationController
  respond_to :json
  
  def index
    @prices = Price.all
    respond_with(@prices)
  end
  
  def show
    @Price = Price.find(params[:id])
    respond_with(@Price)
  end
  
  def create
    price = Price.new(
      :price => params[:value],
      :item => Item.find_by_id(params[:item]),
      :price_date => params[:price_date],
      :currency => Currency.find_by_id(params[:currency])
    )
    
    if price.save
      render :json => { :id => price.id }
    else
      if params.has_key?(:item) && price.item == nil
        price.errors.add(:item, "must be valid")
      end
      if params.has_key?(:currency) && price.currency == nil
        price.errors.add(:currency, "must be valid")
      end
      render :json => { :errors => price.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:product, :item, :retailer, :currency, :date_from, :date_to).empty?
      return render :json => { :errors => { :price => "no search parameters" } }, :status => 400
    end

    where_sql = String.new
    where = Hash.new
    join = Array.new
    
    if params.has_key?(:item)
      unless Item.exists?(params[:item])
        return render :json => { :errors => { :item => "not found" } }, :status => 400
      end
      where[:item_id] = params[:item]
      unless where_sql.empty?
        where_sql += " AND "
      end
      where_sql += "item_id = :item_id"
    end

    if params.has_key?(:currency)
      unless Currency.exists?(params[:currency])
        return render :json => { :errors => { :currency => "not found" } }, :status => 400
      end
      where[:currency_id] = params[:currency]
      unless where_sql.empty?
        where_sql += " AND "
      end
      where_sql += "currency_id = :currency_id"
    end
    
    if params.has_key?(:product)
      unless Product.exists?(params[:product])
        return render :json => { :errors => { :product => "not found" } }, :status => 400
      end
      join.push(:item)
      where[:item] = { :product_id => params[:product] }
    end
    
    puts "join: " + join.join(',')
    puts "where: " + where.to_query
    
    respond_with(Price.joins(join).where(where_sql, where)).limit(5)
  end
end
