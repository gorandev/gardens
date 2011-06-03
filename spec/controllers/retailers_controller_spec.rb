require 'spec_helper'

describe RetailersController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ],
      "country" => [ "can't be blank" ]
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
      post :create, :name => 'Falarino'
      expected["errors"].delete("name")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without a valid country" do
      post :create, :name => 'Falarino', :country => 99
      expected["errors"].delete("name")
      expected["errors"]["country"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :name => 'Falarino', :country => country.id
        response.body.should == "OK"
      end.should change(Retailer, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Retailer.create(:name => 'Falarino', :country => country)
      get :show, :id => 1
      response.should be_ok
    end
  end

end
