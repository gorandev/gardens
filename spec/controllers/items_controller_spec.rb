require 'spec_helper'

describe ItemsController do

  let(:product) { Product.new }
  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
  let(:property_value) { PropertyValue.create(:value => 1, :property => property) }
      
  let(:retailer) {
    Retailer.create(
      :name => 'Falarino',
      :country => Country.create(
        :name => 'Felicidonia',
        :iso_code => 'FD',
        :locale => 'es_FD',
        :time_zone => 'GMT-03:00',
        :currency => Currency.create(:name => 'Felicidon', :symbol => 'F')
      )
    )
  }

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
    it "shouldn't work without retailer" do
      post :create
      response.body.should == "ERROR: no retailer"
    end
    
    it "shouldn't work with an invalid retailer" do
      post :create, :retailer => 99
      response.body.should == "ERROR: no valid retailer type"
    end
    
    it "shouldn't work without at least one property value" do
      post :create, :retailer => retailer.id
      response.body.should == "ERROR: no property values"
    end
    
    it "shouldn't work with invalid property values" do
      post :create, :retailer => retailer.id, :property_values => "99,100,102"
      response.body.should == "ERROR: no valid property values"
    end
    
    it "should work without product" do
      post :create, :retailer => retailer.id, :property_values => property_value.id.to_s
      response.body.should == "OK"
    end
    
    it "should work with product too" do
      post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :product => product.id
      response.body.should == "OK"
    end
    
    it "should work even with an invalid product (it's ignored)" do
      post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :product => 99
      response.body.should == "OK"
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Item.create(:retailer => retailer, :product => product, :property_values => [ property_value ])
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
