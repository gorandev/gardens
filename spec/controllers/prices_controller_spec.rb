require 'spec_helper'

describe PricesController do

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
  let(:property_value) { PropertyValue.create(:value => 1, :property => property) }

  let(:item) { 
    Item.create(
      :retailer => Retailer.create(
        :name => 'Falarino',
        :country => Country.create(
          :name => 'Felicidonia',
          :iso_code => 'FD',
          :locale => 'es_FD',
          :time_zone => 'GMT-03:00',
          :currency => Currency.create(:name => 'Felicidon', :symbol => 'F')
        )
      ),
      :property_values => [ property_value ]
    )
  }
  
  let(:currency) { Currency.create(:name => 'Felicidon', :symbol => 'F') }

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
    
    it "shouldn't work without item" do
      post :create, :value => 99
      response.body.should == "ERROR: no item"
    end
    
    it "shouldn't work with an invalid item" do
      post :create, :value => 99, :item => 99
      response.body.should == "ERROR: no valid item type"
    end
    
    it "shouldn't work with no currency" do
      post :create, :value => 99, :item => item.id
      response.body.should == "ERROR: no currency"
    end
    
    it "shouldn't work with an invalid currency" do
      post :create, :value => 99, :item => item.id, :currency => 99
      response.body.should == "ERROR: no valid currency type"
    end
    
    it "should work with all required values" do
      post :create, :value => 99, :item => item.id, :currency => currency.id
      response.body.should == "OK"
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Price.create(:item => item, :currency => currency, :price => 99)
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
