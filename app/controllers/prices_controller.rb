class PricesController < ApplicationController
  respond_to :json
  
  def index
    @prices = Price.all
    respond_with(@prices)
  end
  
  def show
    @price = Price.find(params[:id])
    respond_with(@price)
  end
  
  def create
    if params.has_key?(:url)
      item = create_item(params)

      unless item.is_a?Item
        return item
      end
      
      unless item.errors.empty?
        return render :json => { :errors => item.errors }, :status => 400
      end
      
      params[:item] = item.id
    end
  
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

    where = Hash.new
    join = Array.new
    
    if params.has_key?(:item)
      unless Item.exists?(params[:item])
        return render :json => { :errors => { :item => "not found" } }, :status => 400
      end
      where[:item_id] = params[:item]
    end

    if params.has_key?(:currency)
      unless Currency.exists?(params[:currency])
        return render :json => { :errors => { :currency => "not found" } }, :status => 400
      end
      where[:currency_id] = params[:currency]
    end
    
    if params.has_key?(:product)
      unless Product.exists?(params[:product])
        return render :json => { :errors => { :product => "not found" } }, :status => 400
      end
      
      if join.index(:item).nil?
        join.push(:item)
      end
      
      if where.has_key?(:items)
        where[:items][:product_id] = params[:product]
      else
        where[:items] = { :product_id => params[:product] }
      end
    end

    if params.has_key?(:retailer)
      unless Retailer.exists?(params[:retailer])
        return render :json => { :errors => { :retailer => "not found" } }, :status => 400
      end
      
      if join.index(:items).nil?
        join.push(:items)
      end

      if where.has_key?(:item)
        where[:items][:retailer_id] = params[:retailer]
      else
        where[:items] = { :retailer_id => params[:retailer] }
      end
    end
    
    params[:date_to] ||= DateTime.now
    params[:date_from] ||= "2000-01-01".to_datetime
    where[:price_date] = (params[:date_from].to_datetime)..(params[:date_to].to_datetime + 1.day)
        
    limit = params[:limit] || 10

    @prices = Price.joins(join).where(where).limit(limit).order("price_date DESC")
    respond_with(@prices)
  end
end