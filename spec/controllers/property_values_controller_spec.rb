require 'spec_helper'

describe PropertyValuesController do

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }

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
    it "shouldn't work without value" do
      post :create
      response.body.should == "ERROR: no value"
    end

    it "shouldn't work without a property" do
      post :create, :value => 9
      response.body.should == "ERROR: no property"
    end

    it "shouldn't work without a valid property" do
      post :create, :value => 9, :property => 99
      response.body.should == "ERROR: no valid property"
    end
    
    it "should work with all required values" do
      post :create, :value => 9, :property => property.id
      response.body.should == "OK"
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      PropertyValue.create(:value => 9, :property => property)
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
