require 'spec_helper'

describe CurrenciesController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_ok
    end
  end
  
  describe "POST 'create'" do
    it "shouldn't work without name" do
      post :create
      response.body.should == "ERROR: no name"
    end
    
    it "shouldn't work without symbol" do
      post :create, :name => 'FLD'
      response.body.should == "ERROR: no symbol"
    end

    it "should save a new currency" do
      post :create, :name => 'FLD', :symbol => 'F$'
      response.body.should == "OK"
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Currency.create(:name => 'FLD', :symbol => 'F$')
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
