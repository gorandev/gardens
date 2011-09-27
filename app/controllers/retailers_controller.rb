require 'ostruct'
class RetailersController < ApplicationController
  respond_to :json
  
  def index
    @retailers = Retailer.all
    respond_with(@retailers)
  end
  
  def show
    @retailer = Retailer.find(params[:id])
    respond_with(@retailer)
  end
  
  def create    
    retailer = Retailer.new( :name => params[:name], :country => Country.find_by_id(params[:country]), :color => params[:color] )
    
    if retailer.save
      render :json => { :id => retailer.id }
    else
      if params.has_key?(:country) && retailer.country.nil?
        retailer.errors.add(:country, "must be valid")
      end
      render :json => { :errors => retailer.errors }, :status => 400
    end
  end
  
  def update
    unless retailer = Retailer.find_by_id(params[:id])
      return render :json => { :errors => { :retailer => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:name)
      retailer.name = params[:name]
    end
    
    if params.has_key?(:country)
      unless country = Country.find_by_id(params[:country])
        return render :json => { :errors => { :country => "must be valid" } }, :status => 400
      else
        retailer.country = country
      end
    end
    
    if retailer.attributes == Retailer.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :retailer => "nothing to update" } }
    end
    
    if retailer.save
      render :json => "OK"
    else
      render :json => { :errors => retailer.errors }, :status => 400
    end
  end
  
  def search
    if params.has_key?(:products) and params.has_key?(:country)
      return _search_fast
    end

    if params.slice(:name, :country).empty?
      return render :json => { :errors => { :retailer => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:country)
      unless Country.find_by_id(params[:country])
        return render :json => { :errors => { :country => "not found" } }, :status => 400
      end
      params[:country_id] = params[:country]
    end

    @retailers = Retailer.where(params.slice(:name, :country_id))
    respond_with(@retailers)
  end
  
  def destroy
    unless retailer = Retailer.find_by_id(params[:id])
      return render :json => { :errors => { :retailer => "must be valid" } }, :status => 400
    end
    retailer.destroy
    render :json => "OK"
  end

  private

  def _search_fast
    product_retailer = Array.new
    params[:products].split(',').each do |p|
      product_retailer.push("retailers.product:#{p}")
    end

    ids_retailers = REDIS.sunion(*product_retailer) & REDIS.smembers('retailers_country:' + params[:country].to_s)

    @retailers = Array.new
    ids_retailers.each do |i|
      @retailers.push(OpenStruct.new({
        :id => i,
        :value => REDIS.get("descripcion.retailer:#{i}")
      }))
    end
    render "search_fast"
  end
end