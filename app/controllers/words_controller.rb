class WordsController < ApplicationController
  respond_to :json
  
  def index
    @words = Word.all
    respond_with(@words)
  end
  
  def show
    @word = Word.find(params[:id])
    respond_with(@word)
  end
  
  def create    
    word = Word.new( :value => params[:value].upcase )
    
    if word.save
      render :json => { :id => word.id }
    else
      render :json => { :errors => word.errors }, :status => 400
    end
  end
  
  def update
    unless word = Word.find_by_id(params[:id])
      return render :json => { :errors => { :word => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:value)
      word.value = params[:value].upcase
    end
    
    if word.attributes == Word.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :word => "nothing to update" } }
    end
    
    if word.save
      render :json => "OK"
    else
      render :json => { :errors => word.errors }, :status => 400
    end
  end
  
  def search
    if params.slice(:misspelling, :word).empty?
      return render :json => { :errors => { :word => "no search parameters" } }, :status => 400
    end
    
    join = Array.new
    if params.has_key?(:misspelling)
      join.push(:misspellings)
      params[:misspellings] = { :value => params[:misspelling].upcase }
    end

    if params.has_key?(:word)
      params[:value] = params[:word].upcase
    end
    
    @words = Word.joins(join).where(params.slice(:value, :misspellings))
    respond_with(@words)
  end
  
  def destroy
    unless word = Word.find_by_id(params[:id])
      return render :json => { :errors => { :word => "must be valid" } }, :status => 400
    end
    word.destroy
    render :json => "OK"
  end
end