require 'spec_helper'

describe ProductTypesController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ]
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
    
    it "should work with all required values" do
      lambda do
        post :create, :name => "Washing machine"
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        ProductType.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(ProductType, :count).by(1)
    end    
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      ProductType.create(:name => 'Washing machine')
      get :show, :id => 1
      response.should be_ok
    end
  end
  
  describe "DELETE /:id" do
    it "shouldn't work with a nonexistent item" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product_type" => "must be valid" } }
    end
  
    it "should work with an existing id" do
      p = ProductType.create(:name => 'Washing machine')
      lambda do
        delete :destroy, :id => p.id
        response.body.should == "OK"
      end.should change(ProductType, :count).by(-1)
    end
  end
  
  describe "SEARCH" do
    before(:each) do
      ProductType.create(:name => 'Washing Machine')
    end
    
    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product_type" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :name => "XXX"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with the name parameter" do
      get :search, :name => "Washing Machine"
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "name"=>"Washing Machine", ""=>[]}]
    end
  end
end