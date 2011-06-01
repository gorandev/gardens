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
    
    it "should work with all required values" do
      lambda do
        Currency.create(:name => 'FLD', :symbol => 'F$')
        post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00', :currency => 1
        response.body.should == "OK"
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
  
end
