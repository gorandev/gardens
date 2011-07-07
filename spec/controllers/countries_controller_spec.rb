require 'spec_helper'

describe CountriesController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ],
      "iso_code" => [ "can't be blank" ],
      "locale" => [ "can't be blank" ],
      "time_zone" => [ "can't be blank" ],
      "currency" => [ "can't be blank" ]
      }
    }
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
    it "shouldn't work without name" do
      post :create
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without iso code" do
      post :create, :name => 'Felicidonia'
      expected["errors"].delete("name")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without locale" do
      post :create, :name => 'Felicidonia', :iso_code => 'FD'
      expected["errors"].delete("name")
      expected["errors"].delete("iso_code")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without time zone" do
      post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD'
      expected["errors"].delete("name")
      expected["errors"].delete("iso_code")
      expected["errors"].delete("locale")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without currency" do
      post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00'
      expected["errors"].delete("name")
      expected["errors"].delete("iso_code")
      expected["errors"].delete("locale")
      expected["errors"].delete("time_zone")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid currency" do
      post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00', :currency => 99
      expected["errors"].delete("name")
      expected["errors"].delete("iso_code")
      expected["errors"].delete("locale")
      expected["errors"].delete("time_zone")
      expected["errors"]["currency"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        Currency.create(:name => 'FLD', :symbol => 'F$')
        post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00', :currency => 1
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Country.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Country, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Country.create(:name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00', :currency => Currency.create(:name => 'FLD', :symbol => 'F$'))
      get :show, :id => 1
      response.should be_ok
    end
  end
  
  describe "PUT /:id" do
  
    let(:currency) { Currency.create(:name => 'FLD', :symbol => 'F$') }
    
    let(:another_currency) { Currency.create(:name => 'SML', :symbol => 'S$') }
  
    let(:country) { Country.create(
      :name => 'Felicidonia',
      :iso_code => 'FD',
      :locale => 'es_FD',
      :time_zone => 'GMT-03:00',
      :currency => currency
      )
    }
  
    it "shouldn't work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "id" => "must be valid" } }
    end
    
    it "shouldn't work without nothing apart from the id" do
      put :update, :id => country.id
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "country" => "nothing to update" } }
    end
    
    it "should work with any single attribute other than currency" do
      [ "name", "iso_code", "locale", "time_zone" ].each { |a|
        put :update, :id => country.id, a.to_sym => "Changed"
        response.body.should == "OK"
        Country.find(country.id).attributes[a].should == "Changed"
      }
    end
    
    it "should work with another currency" do
      put :update, :id => country.id, :currency => another_currency.id
      response.body.should == "OK"
      Country.find(country.id).currency.should == another_currency
    end
    
    it "shouldn't work with an invalid curency" do
      put :update, :id => country.id, :currency => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "currency" => "must be valid" } }
    end
    
    it "should work with all attributes" do
      put :update, :id => country.id, :name => "Changed", :iso_code => "Changed", :locale => "Changed", :time_zone => "Changed", :currency => another_currency.id
      response.body.should == "OK"
      Country.find(country.id).name.should == "Changed"
      Country.find(country.id).iso_code.should == "Changed"
      Country.find(country.id).locale.should == "Changed"
      Country.find(country.id).time_zone.should == "Changed"
      Country.find(country.id).currency.should == another_currency
    end
  end
  
  describe "SEARCH" do
    let(:expected) { [ { "name" => "Felicidonia", "id" => 3 } ] }
  
    before(:each) do
      Country.create(
        :name => 'Felicidonia',
        :iso_code => 'FD',
        :locale => 'es_FD',
        :time_zone => 'GMT-05:00',
        :currency => Currency.create(:name => 'FLD', :symbol => 'F$')
      )
    end
    
    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "country" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :name => "Doesnotexistonia"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with currency name" do
      get :search, :currency => "FLD"
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with currency id" do
      get :search, :currency_id => 3
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work if the currency can't be found" do
      get :search, :currency => "BBB"
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "currency" => "not found" } }
      get :search, :currency_id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "currency" => "not found" } }
    end
    
    it "should work with any single parameter" do
      { "name" => "Felicidonia", "iso_code" => "FD", "locale" => "es_FD", "time_zone" => "GMT-05:00", "currency" => "FLD" }.map { |a, v|
        get :search, a.to_sym => v
        ActiveSupport::JSON.decode(response.body).should == expected
      }
    end
    
    it "should work combining parameters" do
      get :search, :name => "Felicidonia", :locale => "es_FD"
      ActiveSupport::JSON.decode(response.body).should == expected
    end
  end
end