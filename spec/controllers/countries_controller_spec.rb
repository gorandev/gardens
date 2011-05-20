require 'spec_helper'

describe CountriesController do

  describe "GET 'index'" do
    it "should be successful" do
      request.env['HTTP_ACCEPT'] = "application/json" 
      get :index
      response.should be_ok
    end
  end

  describe "GET 'show/1'" do
    it "should be successful" do
      request.env['HTTP_ACCEPT'] = "application/json" 
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
