require 'spec_helper'
include Devise::TestHelpers
describe PricesController do

  let(:expected) {
    { "errors" => {
      "item" => [ "can't be blank" ],
      "currency" => [ "can't be blank" ],
      "price" => [ "can't be blank" ]
      }
    }
  }

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
        ),
        :color => '#FFFFFF'
      ),
      :product_type => product_type,
      :source => 'web',
      :property_values => [ property_value ],
      :url => 'http://www.falarino.com'
    )
  }
  
  let(:currency) { Currency.create(:name => 'Felicidon', :symbol => 'F') }
  
  let(:date) { Date.current }

  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = Factory(:user)
    sign_in @user
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
    
    it "shouldn't work without item" do
      post :create, :value => 99
      expected["errors"].delete("price")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid item" do
      post :create, :value => 99, :item => 99
      expected["errors"].delete("price")
      expected["errors"]["item"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with no currency" do
      post :create, :value => 99, :item => item.id
      expected["errors"].delete("price")
      expected["errors"].delete("item")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid currency" do
      post :create, :value => 99, :item => item.id, :currency => 99
      expected["errors"].delete("price")
      expected["errors"].delete("item")
      expected["errors"]["currency"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :value => 99, :item => item.id, :currency => currency.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Price.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Price, :count).by(1)
    end
    
    it "shouldn't work with url but an invalid item" do
      post :create, :value => 99, :currency => currency.id, :product_type => product_type.id, :source => 'web', :url => 'http://www.xyzzy.com'
      response.should_not be_ok
      post :create, :value => 99, :currency => currency.id, :retailer => item.retailer.id, :source => 'web', :url => 'http://www.whongo.com'
      response.should_not be_ok
      post :create, :value => 99, :currency => currency.id, :retailer => item.retailer.id, :product_type => product_type.id, :url => 'http://www.saburo.com'
      response.should_not be_ok
    end
    
    it "should work with the item object -- and two price inputs for the same item and date should generate 1 item, 1 price and 1 event" do
      lambda do
        lambda do
          lambda do
            post :create, :value => 99, :currency => currency.id, :retailer => item.retailer.id, :product_type => product_type.id, :source => 'web', :url => 'http://www.falarino.com', :scraped => 1
            response.should be_ok
            ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
            Price.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
            
            post :create, :value => 101, :currency => currency.id, :retailer => item.retailer.id, :product_type => product_type.id, :source => 'web', :url => 'http://www.falarino.com', :scraped => 1
            response.should be_ok
            ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
            Price.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
            
            Event.where(:item_id => item.id).last.precio_viejo.should == 99
            Event.where(:item_id => item.id).last.precio_nuevo.should == 101
            
            post :create, :value => 101, :currency => currency.id, :retailer => item.retailer.id, :product_type => product_type.id, :source => 'web', :url => 'http://www.falarino.com', :scraped => 1, :price_date => Date.current + 1.day
            response.should be_ok
            ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
            Price.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]            
          end.should change(Event, :count).by(1)
        end.should change(Price, :count).by(2)
      end.should change(Item, :count).by(1)
    end
    
    it "shouldn't create an event when you are not submitting the latest price" do
      lambda do
        lambda do
          lambda do
            post :create, :value => 99, :currency => currency.id, :retailer => item.retailer.id, :product_type => product_type.id, :source => 'web', :url => 'http://www.falarino.com', :price_date => Date.current - 4.day, :scraped => 1
            response.should be_ok
            ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
            Price.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
            
            post :create, :value => 99, :currency => currency.id, :retailer => item.retailer.id, :product_type => product_type.id, :source => 'web', :url => 'http://www.falarino.com', :price_date => Date.current - 2.day, :scraped => 1
            response.should be_ok
            ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
            Price.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
            
            post :create, :value => 101, :currency => currency.id, :retailer => item.retailer.id, :product_type => product_type.id, :source => 'web', :url => 'http://www.falarino.com', :price_date => Date.current - 3.day, :scraped => 1
            response.should be_ok
            ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
            Price.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
          end.should change(Price, :count).by(3)
        end.should change(Event, :count).by(0)
      end.should change(Item, :count).by(1)
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      Price.create(:item => item, :currency => currency, :price => 101, :price_date => Date.current)
      get :show, :id => 1
      response.should be_ok
    end
  end

  describe "SEARCH" do
    let(:expected) { [ { "name" => "Felicidonia", "id" => 1 } ] }

    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "price" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :currency => currency.id
      ActiveSupport::JSON.decode(response.body).should == []
    end

    it "should work with any single parameter" do
      Price.create(:item => item, :currency => currency, :price => 99, :price_date => date)
      { "item" => item.id, "currency" => currency.id }.map { |a, v|
        get :search, a.to_sym => v
        ActiveSupport::JSON.decode(response.body).should == [{"price"=>99, "price_date"=> date.strftime, "item"=>1, "retailer" => "Falarino", "retailer_color" => "#FFFFFF", "currency"=>"Felicidon" }]
      }
    end
    
    it "should work combining parameters" do
      Price.create(:item => item, :currency => currency, :price => 99, :price_date => date)
      get :search, :item => item.id, :currency => currency.id
      ActiveSupport::JSON.decode(response.body).should == [{"price"=>99, "price_date"=> date.strftime, "item"=>1, "retailer" => "Falarino", "retailer_color" => "#FFFFFF", "currency"=>"Felicidon"}]
    end
  end  
end