class NoWordsController < ApplicationController
  respond_to :json
  
  def index
    @no_words = NoWord.all
    respond_with(@no_words)
  end
  
  def show
    @no_word = NoWord.find(params[:id])
    respond_with(@no_word)
  end
  
  def create    
    no_word = NoWord.new( :value => params[:value] )
    
    no_word.value = no_word.value.upcase unless no_word.value.nil?
    
    if no_word.save
      render :json => { :id => no_word.id }
    else
      render :json => { :errors => no_word.errors }, :status => 400
    end
  end
  
  def update
    unless no_word = NoWord.find_by_id(params[:id])
      return render :json => { :errors => { :no_word => "must be valid" } }, :status => 400
    end
    
    if params.has_key?(:value)
      no_word.value = params[:value].upcase
    end
    
    if no_word.attributes == NoWord.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :no_word => "nothing to update" } }
    end
    
    if no_word.save
      render :json => "OK"
    else
      render :json => { :errors => no_word.errors }, :status => 400
    end
  end
  
  def search
    unless params.has_key?(:word)
      return render :json => { :errors => { :no_word => "no search parameters" } }, :status => 400
    end

    @no_words = NoWord.where(:value => params[:word].upcase)
    respond_with(@no_words)
  end
  
  def destroy
    unless no_word = NoWord.find_by_id(params[:id])
      return render :json => { :errors => { :no_word => "must be valid" } }, :status => 400
    end
    no_word.destroy
    render :json => "OK"
  end
end