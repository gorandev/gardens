require 'spec_helper'

describe PropertiesController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ],
      "product_type" => [ "can't be blank" ]
      }
    }
  }

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:another_product_type) { ProductType.create(:name => 'Choker') }

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

    it "shouldn't work without product type" do
      post :create, :name => 'Tonnage'
      expected["errors"].delete("name")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with an invalid product type" do
      post :create, :name => 'Tonnage', :product_type => 99
      expected["errors"].delete("name")
      expected["errors"]["product_type"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :name => 'Tonnage', :product_type => product_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Property.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Property, :count).by(1)
    end
    
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Property.create(:name => 'Washing Tonnage', :product_type => product_type)
      get :show, :id => 1
      response.should be_ok
    end
  end

  describe "DELETE /:id" do
    it "shouldn't work with an invalid id" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property" => "must be valid" } }
    end
  
    it "should work with a valid id" do
      Property.create(:name => 'Washing Tonnage', :product_type => product_type)
      lambda do
        delete :destroy, :id => 1
        response.body.should == "OK"
      end.should change(Property, :count).by(-1)
    end
  end
  
  describe "PUT /:id" do  
    let(:property) {
      property = Property.create(:name => 'Washing Tonnage', :product_type => product_type)
    }
  
    it "shouldn't work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property" => "must be valid" } }
    end
    
    it "shouldn't work without nothing apart from the id" do
      put :update, :id => property.id
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property" => "nothing to update" } }
    end
    
    it "should work with any single attribute other than currency" do
      put :update, :id => property.id, :name => "Grundig TV"
      response.body.should == "OK"
      Property.find(property.id).name.should == "Grundig TV"
      
      put :update, :id => property.id, :product_type => another_product_type
      response.body.should == "OK"
      Property.find(property.id).product_type.should == another_product_type
    end    
    
    it "should work with all attributes" do
      put :update, :id => property.id, :name => "Grundig TV", :product_type => another_product_type
      response.body.should == "OK"
      Property.find(property.id).name.should == "Grundig TV"
      Property.find(property.id).product_type.should == another_product_type
    end
  end
  
  describe "SEARCH" do
    before(:each) do
      Property.create(:name => 'Washing Tonnage', :product_type => product_type)
    end

    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :name => "XXX"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with any single parameter" do
      get :search, :name => 'Washing Tonnage'
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "name"=>"Washing Tonnage", "possible_values"=>[], "product_type_id"=>1, "product_type_name"=>"Squeezer"}]
      get :search, :product_type => product_type.id
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "name"=>"Washing Tonnage", "possible_values"=>[], "product_type_id"=>1, "product_type_name"=>"Squeezer"}]
    end
    
    it "should work with more than one parameter" do
      get :search, :name => 'Washing Tonnage', :product_type => product_type.id
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "name"=>"Washing Tonnage", "possible_values"=>[], "product_type_id"=>1, "product_type_name"=>"Squeezer"}]
    end
  end
end