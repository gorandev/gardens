require 'spec_helper'

describe ProductsController do

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
      response.body.should == "ERROR: no product type"
    end

    it "shouldn't work with an invalid product type" do
      post :create, :product_type => 99
      response.body.should == "ERROR: no valid product type"
    end
    
    it "shouldn't work without at least one property value" do
      post :create, :product_type => product_type.id
      response.body.should == "ERROR: no property values"
    end

    it "shouldn't work with invalid property values" do
      post :create, :product_type => product_type.id, :property_values => "99"
      response.body.should == "ERROR: no valid property values"
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
