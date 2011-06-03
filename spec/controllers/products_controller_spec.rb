require 'spec_helper'

describe ProductsController do

  let(:expected) {
    { "errors" => {
      "product_type" => [ "can't be blank" ],
      "property_values" => [ "can't be blank" ]
      }
    }
  }

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
  let(:property_value) { PropertyValue.create(:value => 1, :property => property) }

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
    it "shouldn't work without product type" do
      post :create
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with an invalid product type" do
      post :create, :product_type => 99
      expected["errors"]["product_type"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without at least one property value" do
      post :create, :product_type => product_type.id
      expected["errors"].delete("product_type")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with any invalid property values" do
      post :create, :product_type => product_type.id, :property_values => property_value.id.to_s + ",99"
      expected["errors"].delete("product_type")
      expected["errors"]["property_values"].push("must be all valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :product_type => product_type.id, :property_values => property_value.id.to_s
        response.body.should == "OK"
      end.should change(Product, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Product.create( :product_type => product_type, :property_values => [ property_value ] )
      get :show, :id => 1
      response.should be_ok
    end
  end

end
