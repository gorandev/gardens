require 'spec_helper'

describe ItemsController do

  let(:expected) {
    { "errors" => {
      "retailer" => [ "can't be blank" ],
      "property_values" => [ "can't be blank" ],
      "product_type" => [ "can't be blank" ],
      "source" => [ "can't be blank", "is not included in the list" ]
      }
    }
  }

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:another_product_type) { ProductType.create(:name => 'Choker') }  
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
  let(:property_value) { PropertyValue.create(:value => 1, :property => property) }
  let(:another_property_value) { PropertyValue.create(:value => 2, :property => property) }
  let(:a_third_property_value) { PropertyValue.create(:value => 3, :property => property) }
   
  let(:currency) { Currency.create(:name => 'Felicidon', :symbol => 'F') }
   
  let(:country) { Country.create(
    :name => 'Felicidonia',
    :iso_code => 'FD',
    :locale => 'es_FD',
    :time_zone => 'GMT-03:00',
    :currency => currency
  )}
    
  let(:retailer) { Retailer.create( :name => 'Falarino', :country => country ) }
  let(:another_retailer) { Retailer.create(:name => 'La Povega', :country => country) }
  
  let(:product) { Product.create(:product_type => product_type, :property_values => [ property_value ]) }
  let(:item) { Item.create(:retailer => retailer, :source => 'web', :property_values => [ property_value ], :product_type => product_type) }
  
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
    it "shouldn't work without retailer" do
      post :create
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid retailer" do
      post :create, :retailer => 99
      expected["errors"]["retailer"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without at least one property value and a source" do
      post :create, :retailer => retailer.id
      expected["errors"].delete("retailer")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with any invalid property values" do
      post :create, :retailer => retailer.id, :property_values => property_value.id.to_s + ',' + another_property_value.id.to_s + ',100'
      expected["errors"].delete("retailer")
      expected["errors"]["property_values"].push("must be all valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid product" do
      post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :product => 99, :source => 'web'
      expected["errors"].delete("retailer")
      expected["errors"].delete("property_values")
      expected["errors"].delete("product_type")
      expected["errors"].delete("source")
      expected["errors"]["product"] = "must be valid"
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work without product and a single property value and a source and a product type" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :source => 'web', :product_type => product_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).retailer.should == retailer
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).property_values.should == [ property_value ]
      end.should change(Item, :count).by(1)
    end

    it "shouldn't work with an invalid source" do
      post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :source => 'blagh'
      expected["errors"].delete("retailer")
      expected["errors"].delete("property_values")
      expected["errors"]["source"] = [ "is not included in the list" ]
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work without product and more than one property value via comma separated string" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s + ',' + another_property_value.id.to_s, :source => 'web', :product_type => product_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).retailer.should == retailer
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).property_values.should == [ property_value, another_property_value ]
      end.should change(Item, :count).by(1)
    end    
    
    it "should work without product and more than one property value via array of ids" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => [ property_value.id, another_property_value.id ], :source => 'web', :product_type => product_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).retailer.should == retailer
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).property_values.should == [ property_value, another_property_value ]
      end.should change(Item, :count).by(1)
    end
    
    it "should work with product and a single property value" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :product => product.id, :source => 'web', :product_type => product_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).retailer.should == retailer
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).product.should == product
      end.should change(Item, :count).by(1)
    end

    it "should work with product and more than one property value via comma separated string" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s + ',' + another_property_value.id.to_s, :product => product.id, :source => 'web', :product_type => product_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).retailer.should == retailer
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).product.should == product
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).property_values.should == [ property_value, another_property_value ]
      end.should change(Item, :count).by(1)
    end    
    
    it "should work with product and more than one property value via array of ids" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => [ property_value.id, another_property_value.id ], :product => product.id, :source => 'web', :product_type => product_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).retailer.should == retailer
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).product.should == product
        Item.find(ActiveSupport::JSON.decode(response.body)["id"]).property_values.should == [ property_value, another_property_value ]
      end.should change(Item, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Item.create(:retailer => retailer, :product => product, :property_values => [ property_value ], :source => 'web', :product_type => product_type)
      get :show, :id => 1
      response.should be_ok
    end
  end
  
  describe "DELETE /:id" do
    it "shouldn't work with a nonexistent item" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "item" => "must be valid" } }
    end
  
    it "should work" do
      Item.create(:retailer => retailer, :product => product, :property_values => [ property_value ], :source => 'web', :product_type => product_type)
      lambda do
        delete :destroy, :id => 1
        response.body.should == "OK"
      end.should change(Item, :count).by(-1)
    end
  end
  
  describe "PUT /:id" do      
    it "should not work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "id" => "must be valid" } }
    end
    
    it "should work with a valid retailer" do
      put :update, :id => item.id, :retailer => another_retailer.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
    end

    it "shouldn't work with an invalid retailer" do
      put :update, :id => item.id, :retailer => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "retailer" => "must be valid" } }
    end

    it "should work with a valid product type" do
      put :update, :id => item.id, :product_type => another_product_type.id
      response.body.should == "OK"
      Item.find(item.id).product_type.should == another_product_type
    end
    
    it "shouldn't work with an invalid product type" do
      put :update, :id => item.id, :product_type => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product_type" => "must be valid" } }
    end
    
    it "should work with a valid product" do
      put :update, :id => item.id, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).product.should == product
    end

    it "shouldn't work with an invalid product" do
      put :update, :id => item.id, :product => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product" => "must be valid" } }
    end
    
    it "should work with a retailer *and* a product" do
      put :update, :id => item.id, :product => product.id, :retailer => another_retailer.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).product.should == product
    end

    it "should work with a valid single property value" do
      put :update, :id => item.id, :property_values => [ another_property_value.id ]
      response.body.should == "OK"
      Item.find(item.id).property_values.should == [ another_property_value ]
    end
    
    it "should *add* the property values if it's a comma separated string" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s
      response.body.should == "OK"
      Item.find(item.id).property_values.should == [ property_value, another_property_value, a_third_property_value ]
    end

    it "shouldn't work with an invalid single property value" do
      put :update, :id => item.id, :property_values => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "must be all valid" } }
    end

    it "shouldn't work even if only one property value is invalid" do
      put :update, :id => item.id, :retailer => another_retailer.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s + ",99"
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "must be all valid" } }
    end
    
    it "should work with a valid single property value and a retailer" do
      put :update, :id => item.id, :retailer => another_retailer.id, :property_values => [ another_property_value.id ]
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).property_values.should == [ another_property_value ]
    end
    
    it "should work with a valid single property value and a product" do
      put :update, :id => item.id, :property_values => [ another_property_value.id ], :product => product.id
      response.body.should == "OK"
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value ]
    end
    
    it "should work with a valid single property value and a retailer *and* a product" do
      put :update, :id => item.id, :property_values => [ another_property_value.id ], :retailer => another_retailer.id, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value ]
    end
    
    it "should work with more than one valid property value" do
      put :update, :id => item.id, :property_values => [ another_property_value.id, a_third_property_value.id ]
      response.body.should == "OK"
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
    
    it "should work with more than one valid property value and a retailer" do
      put :update, :id => item.id, :property_values => [ another_property_value.id, a_third_property_value.id ], :retailer => another_retailer.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
    
    it "should work with more than one valid property value and a product" do
      put :update, :id => item.id, :property_values => [ another_property_value.id, a_third_property_value.id ], :product => product.id
      response.body.should == "OK"
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
    
    it "should work with more than one valid property value and a retailer *and* a product" do
      put :update, :id => item.id, :property_values => [ another_property_value.id, a_third_property_value.id ], :retailer => another_retailer.id, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
  end
  
  describe "SEARCH" do
    let(:expected) { [ { "name" => "Felicidonia", "id" => 3 } ] }

    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "item" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :retailer => 1
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "shouldn't work with an invalid retailer" do
      get :search, :retailer => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "retailer" => "not found" } }
    end
    
    it "shouldn't work with an invalid product" do
      get :search, :product => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product" => "not found" } }
    end

    it "shouldn't work with an invalid product type" do
      get :search, :product_type => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product_type" => "not found" } }
    end
    
    it "shouldn't work with invalid property values" do
      get :search, :property_values => nil
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "must be comma-separated string or JSON array" } }
      get :search, :property_values => "99, 100, 101"
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "not found" } }
      get :search, :property_values => [ 99, 100, 101 ]
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "not found" } }
    end
    
    it "should work with any single parameter" do
      put :update, :id => item.id, :product => product.id
      response.body.should == "OK"
      { "retailer" => retailer.id, "product" => product.id, "source" => "web" }.map { |a, v|
        get :search, a.to_sym => v
        ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "source"=>"web", "property_values"=>[{"id"=>16, "value"=>"1", "property_id"=>6, "property_name"=>"watts"}], "product"=>3, "retailer"=>"Falarino", "product_type_id"=>3, "product_type_name"=>"Squeezer"}]
      }
    end
    
    it "should work combining parameters" do
      put :update, :id => item.id, :product => product.id, :source => "web"
      response.body.should == "OK"
      get :search, :retailer => retailer.id, :product => product.id
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "source"=>"web", "property_values"=>[{"id"=>16, "value"=>"1", "property_id"=>6, "property_name"=>"watts"}], "product"=>3, "retailer"=>"Falarino", "product_type_id"=>3, "product_type_name"=>"Squeezer"}]
    end
    
    it "should work with one property value" do
      put :update, :id => item.id, :property_values => [ property_value.id ]
      response.body.should == "OK"
      get :search, :property_values => property_value.id.to_s
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "source"=>"web", "property_values"=>[{"id"=>16, "value"=>"1", "property_id"=>6, "property_name"=>"watts"}], "retailer"=>"Falarino", "product_type_id"=>3, "product_type_name"=>"Squeezer"}]
    end
    
    it "should work with more than one property value" do
      put :update, :id => item.id, :property_values => [ property_value.id, another_property_value.id ]
      response.body.should == "OK"
      get :search, :property_values => property_value.id.to_s + "," + another_property_value.id.to_s
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "source"=>"web", "property_values"=>[{"id"=>16, "value"=>"1", "property_id"=>6, "property_name"=>"watts"}, {"id"=>17, "value"=>"2", "property_id"=>6, "property_name"=>"watts"}], "retailer"=>"Falarino", "product_type_id"=>3, "product_type_name"=>"Squeezer"}]
    end    
  end
end