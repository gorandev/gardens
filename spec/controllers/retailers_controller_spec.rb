require 'spec_helper'

describe RetailersController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ],
      "country" => [ "can't be blank" ],
      "color" => [ "can't be blank"]
      }
    }
  }

  let (:currency) { Currency.create(:name => 'Felicidon', :symbol => 'F') }
  let (:country) { Country.create(
    :name => 'Felicidonia',
    :iso_code => 'FD',
    :locale => 'es_FD',
    :time_zone => 'GMT-03:00',
    :currency => currency
  ) }
  let (:another_country) { Country.create(
    :name => 'Bologna',
    :iso_code => 'BG',
    :locale => 'es_BG',
    :time_zone => 'GMT-03:00',
    :currency => currency
  ) }

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

    it "shouldn't work without country" do
      post :create, :name => 'Falarino', :color => '#FFFFFF'
      expected["errors"].delete("name")
      expected["errors"].delete("color")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without a valid country" do
      post :create, :name => 'Falarino', :country => 99, :color => '#FFFFFF'
      expected["errors"].delete("name")
      expected["errors"].delete("color")
      expected["errors"]["country"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without color" do
      post :create, :name => 'Falarino', :country => country.id
      expected["errors"].delete("name")
      expected["errors"].delete("country")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "should work with all required values" do
      lambda do
        post :create, :name => 'Falarino', :country => country.id, :color => '#FFFFFF'
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Retailer.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Retailer, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Retailer.create(:name => 'Falarino', :country => country, :color => '#FFFFFF')
      get :show, :id => 1
      response.should be_ok
    end
  end

  describe "DELETE /:id" do
    it "shouldn't work with an invalid id" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "retailer" => "must be valid" } }
    end
  
    it "should work with a valid id" do
      Retailer.create(:name => 'Falarino', :country => country, :color => '#FFFFFF')
      lambda do
        delete :destroy, :id => 1
        response.body.should == "OK"
      end.should change(Retailer, :count).by(-1)
    end
  end
  
  describe "PUT /:id" do  
    let(:retailer) {
      retailer = Retailer.create(:name => 'Falarino', :country => country, :color => '#FFFFFF')
    }
  
    it "shouldn't work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "retailer" => "must be valid" } }
    end
    
    it "shouldn't work without nothing apart from the id" do
      put :update, :id => retailer.id
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "retailer" => "nothing to update" } }
    end
    
    it "shouldn't work with an invalid country" do
      put :update, :id => retailer.id, :country => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "country" => "must be valid" } }
    end
    
    it "should work with a valid country" do
      put :update, :id => retailer.id, :country => another_country.id
      response.body.should == "OK"
      Retailer.find(retailer.id).country.should == another_country
    end
    
    it "should work with a name value" do
      put :update, :id => retailer.id, :name => 'Otronombre'
      response.body.should == "OK"
      Retailer.find(retailer.id).name.should == 'Otronombre'
    end
    
    it "shouldn't work with a name and an invalid country" do
      put :update, :id => retailer.id, :name => 'Otronombre', :country => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "country" => "must be valid" } }
    end
    
    it "should work with a name and a country" do
      put :update, :id => retailer.id, :name => 'Otronombre', :country => another_country.id
      response.body.should == "OK"
      Retailer.find(retailer.id).country.should == another_country
      Retailer.find(retailer.id).name.should == 'Otronombre'
    end
  end
  
  describe "SEARCH" do
    before(:each) do
      Retailer.create(:name => 'Falarino', :country => country, :color => '#FFFFFF')
    end

    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "retailer" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :name => "XXX"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with any single parameter" do
      get :search, :name => 'Falarino'
      ActiveSupport::JSON.decode(response.body).should == [{"name"=>"Falarino", "country"=>"Felicidonia", "id"=>1}]
      get :search, :country => country.id
      ActiveSupport::JSON.decode(response.body).should == [{"name"=>"Falarino", "country"=>"Felicidonia", "id"=>1}]
    end
    
    it "should work with more than one parameter" do
      get :search, :name => 'Falarino', :country => country.id
      ActiveSupport::JSON.decode(response.body).should == [{"name"=>"Falarino", "country"=>"Felicidonia", "id"=>1}]
    end
  end
end