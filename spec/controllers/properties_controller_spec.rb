require 'spec_helper'

describe PropertiesController do

  let(:product_type) { ProductType.create(:name => 'Squeezer') }

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

    it "shouldn't work without product type" do
      post :create, :name => 'Tonnage'
      response.body.should == "ERROR: no product type"
    end

    it "shouldn't work without a valid product type" do
      post :create, :name => 'Tonnage', :product_type => 99
      response.body.should == "ERROR: no valid product type"
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :name => 'Tonnage', :product_type => product_type.id
        response.body.should == "OK"
      end.should change(Property, :count).by(1)
    end
    
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Property.create(:name => 'Washing Tonnage', :product_type => product_type)
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
