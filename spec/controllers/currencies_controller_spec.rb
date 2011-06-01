require 'spec_helper'

describe CurrenciesController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ],
      "symbol" => [ "can't be blank" ]
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
    
    it "shouldn't work without symbol" do
      post :create, :name => 'FLD'
      expected["errors"].delete("name")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "should work with all required values" do
      lambda do
        post :create, :name => 'FLD', :symbol => 'F$'
        response.body.should == "OK"
      end.should change(Currency, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Currency.create(:name => 'FLD', :symbol => 'F$')
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
