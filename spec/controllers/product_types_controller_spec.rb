require 'spec_helper'

describe ProductTypesController do

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
    
    it "should work with all required values" do
      lambda do
        post :create, :name => "Washing machine"
        response.body.should == "OK"
      end.should change(ProductType, :count).by(1)
    end    
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      ProductType.create(:name => 'Washing machine')
      get :show, :id => 1
      response.should be_ok
    end
  end
end