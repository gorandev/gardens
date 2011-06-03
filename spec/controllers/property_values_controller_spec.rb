require 'spec_helper'

describe PropertyValuesController do

  let(:expected) {
    { "errors" => {
      "value" => [ "can't be blank" ],
      "property" => [ "can't be blank" ]
      }
    }
  }

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
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work without a property" do
      post :create, :value => 9
      expected["errors"].delete("value")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with an invalid property" do
      post :create, :value => 9, :property => 99
      expected["errors"].delete("value")
      expected["errors"]["property"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :value => 9, :property => property.id
        response.body.should == "OK"
      end.should change(PropertyValue, :count).by(1)
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
