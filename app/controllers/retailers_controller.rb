class RetailersController < ApplicationController
  respond_to :json
  
  def index
    @retailers = Retailer.all
    respond_with(@retailers)
  end
  
  def show
    @Retailer = Retailer.find(params[:id])
    respond_with(@Retailer)
  end
  
  def create    
    retailer = Retailer.new( :name => params[:name], :country => Country.find_by_id(params[:country]) )
    
    if retailer.save
      render :json => "OK"
    else
      if params.has_key?(:country)
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
    if params.slice(:name, :country).empty?
      return render :json => { :errors => { :retailer => "no search parameters" } }, :status => 400
    end

    if params.has_key?(:country)
      unless Country.find_by_id(params[:country])
        return render :json => { :errors => { :country => "not found" } }, :status => 400
      end
      params[:country_id] = params[:country]
    end
    
    respond_with(Retailer.where(params.slice(:name, :country_id)))
  end
  
  def destroy
    unless retailer = Retailer.find_by_id(params[:id])
      return render :json => { :errors => { :retailer => "must be valid" } }, :status => 400
    end
    retailer.destroy
    render :json => "OK"
  end
end