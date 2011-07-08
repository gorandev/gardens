require 'spec_helper'

describe PropertyValuesController do

  let(:expected) {
    { "errors" => {
      "value" => [ "can't be blank" ],
      "property" => [ "can't be blank" ]
      }
    }
  }

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
  let(:another_property) { Property.create(:name => 'gigawatts', :product_type => product_type) }

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
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work without a property" do
      post :create, :value => 9
      expected["errors"].delete("value")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with an invalid property" do
      post :create, :value => 9, :property => 99
      expected["errors"].delete("value")
      expected["errors"]["property"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :value => 9, :property => property.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        PropertyValue.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(PropertyValue, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      PropertyValue.create(:value => 9, :property => property)
      get :show, :id => 1
      response.should be_ok
    end
  end

  describe "DELETE /:id" do
    it "shouldn't work with an invalid id" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_value" => "must be valid" } }
    end
  
    it "should work with a valid id" do
      PropertyValue.create(:value => 9, :property => property)
      lambda do
        delete :destroy, :id => 1
        response.body.should == "OK"
      end.should change(PropertyValue, :count).by(-1)
    end
  end
  
  describe "PUT /:id" do  
    let(:property_value) {
      property_value = PropertyValue.create(:value => 42, :property => property)
    }
  
    it "shouldn't work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_value" => "must be valid" } }
    end
    
    it "shouldn't work without nothing apart from the id" do
      put :update, :id => property_value.id
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_value" => "nothing to update" } }
    end
    
    it "shouldn't work with an invalid property" do
      put :update, :id => property_value.id, :property => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property" => "must be valid" } }
    end
    
    it "should work with an existing property" do
      put :update, :id => property_value.id, :property => another_property.id
      response.body.should == "OK"
      PropertyValue.find(property_value.id).property.should == another_property
    end
    
    it "should work with a value attribute" do
      put :update, :id => property_value.id, :value => 28
      response.body.should == "OK"
      PropertyValue.find(property_value.id).value.should == "28"
    end    
    
    it "should work with all attributes" do
      put :update, :id => property_value.id, :value => 28, :property => another_property.id
      response.body.should == "OK"
      PropertyValue.find(property_value.id).value.should == "28"
      PropertyValue.find(property_value.id).property.should == another_property
    end
  end
  
  describe "SEARCH" do
    before(:each) {
      PropertyValue.create(:value => 42, :property => property)
    }

    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_value" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :value => "XXX"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with any single parameter" do
      get :search, :value => 42
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "value"=>"42", "property_id"=>1, "property_name"=>"watts", "product_type_id"=>1, "product_type_name"=>"Squeezer"}]
      get :search, :property => property.id
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "value"=>"42", "property_id"=>1, "property_name"=>"watts", "product_type_id"=>1, "product_type_name"=>"Squeezer"}]
    end
    
    it "should work with more than one parameter" do
      get :search, :value => 42, :property => property.id
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "value"=>"42", "property_id"=>1, "property_name"=>"watts", "product_type_id"=>1, "product_type_name"=>"Squeezer"}]
    end
  end
end
