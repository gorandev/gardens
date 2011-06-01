require 'spec_helper'

describe PropertiesController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ],
      "product_type" => [ "can't be blank" ]
      }
    }
  }

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
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work without product type" do
      post :create, :name => 'Tonnage'
      expected["errors"].delete("name")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work without a valid product type" do
      post :create, :name => 'Tonnage', :product_type => 99
      expected["errors"].delete("name")
      ActiveSupport::JSON.decode(response.body).should == expected
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
