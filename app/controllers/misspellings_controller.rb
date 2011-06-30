class MisspellingsController < ApplicationController
  respond_to :json
  
  def index
    @misspellings = Misspelling.all
    respond_with(@misspellings)
  end
  
  def show
    @misspelling = Misspelling.find(params[:id])
    respond_with(@misspelling)
  end
  
  def create
    misspelling = Misspelling.new( :value => params[:value].upcase, :word => Word.find_by_id(params[:word]) )
    
    if misspelling.save
      render :json => { :id => misspelling.id }
    else
      if params.has_key?(:word)
        misspelling.errors.add(:word, "must be valid")
      end
      render :json => { :errors => misspelling.errors }, :status => 400
    end
  end
  
  def update
    unless misspelling = Misspelling.find_by_id(params[:id])
      return render :json => { :errors => { :misspelling => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:value)
      misspelling.value = params[:value].upcase
    end
    
    if params.has_key?(:word)
      unless word = Word.find_by_id(params[:word])
        return render :json => { :errors => { :word => "must be valid" } }, :status => 400
      else
        misspelling.word = word
      end
    end
    
    if misspelling.attributes == Misspelling.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :misspelling => "nothing to update" } }
    end
    
    if misspelling.save
      render :json => "OK"
    else
      render :json => { :errors => misspelling.errors }, :status => 400
    end
  end
  
  def search    
    if params.slice(:value, :word).empty?
      return render :json => { :errors => { :misspelling => "no search parameters" } }, :status => 400
    end

    join = Array.new
    if params.has_key?(:word)
      join.push(:word)
      params[:words] = { :value => params[:word].upcase }
    end
    
    @misspellings = Misspelling.joins(join).where(params.slice(:value, :words))
    respond_with(@misspellings)
  end
  
  def destroy
    unless misspelling = Misspelling.find_by_id(params[:id])
      return render :json => { :errors => { :misspelling => "must be valid" } }, :status => 400
    end
    misspelling.destroy
    render :json => "OK"
  end
end