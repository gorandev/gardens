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
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Currency.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Currency, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Currency.create(:name => 'FLD', :symbol => 'F$')
      get :show, :id => 3
      response.should be_ok
    end
  end

  describe "DELETE /:id" do
    it "shouldn't work with a nonexistent item" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "currency" => "must be valid" } }
    end
  
    it "should work" do
      c = Currency.create(:name => 'FLD', :symbol => 'F$')
      lambda do
        delete :destroy, :id => c.id
        response.body.should == "OK"
      end.should change(Currency, :count).by(-1)
    end
  end
  
  describe "PUT /:id" do  
    let(:currency) { Currency.create(:name => 'FLD', :symbol => 'F$') }
  
    it "shouldn't work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "id" => "must be valid" } }
    end
    
    it "shouldn't work without nothing apart from the id" do
      put :update, :id => currency.id
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "currency" => "nothing to update" } }
    end
    
    it "should work with any single attribute other than currency" do
      [ "name", "symbol" ].each { |a|
        put :update, :id => currency.id, a.to_sym => "Changed"
        response.body.should == "OK"
        Currency.find(currency.id).attributes[a].should == "Changed"
      }
    end    
    
    it "should work with all attributes" do
      put :update, :id => currency.id, :name => "Changed", :symbol => "Changed"
      response.body.should == "OK"
      Currency.find(currency.id).name.should == "Changed"
      Currency.find(currency.id).symbol.should == "Changed"
    end
  end
  
  describe "SEARCH" do
    before(:each) do
      Currency.create(:name => 'FLD', :symbol => 'F$')
    end
    
    let(:expected) { [ { "name" => "FLD", "symbol" => 'F$', "id" => 3 } ] }
    
    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "currency" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :name => "XXX"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with any single parameter" do
      { "name" => "FLD", "symbol" => "F$" }.map { |a, v|
        get :search, a.to_sym => v
        ActiveSupport::JSON.decode(response.body).should == expected
      }
    end
  end
end
