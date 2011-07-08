require 'spec_helper'

describe ProductsController do

  let(:expected) {
    { "errors" => {
      "product_type" => [ "can't be blank" ],
      "property_values" => [ "can't be blank" ]
      }
    }
  }

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:another_product_type) { ProductType.create(:name => 'Choker') }
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
  let(:property_value) { PropertyValue.create(:value => 1, :property => property) }
  let(:another_property_value) { PropertyValue.create(:value => 2, :property => property) }
  let(:a_third_property_value) { PropertyValue.create(:value => 2, :property => property) }

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
    it "shouldn't work without product type" do
      post :create
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with an invalid product type" do
      post :create, :product_type => 99
      expected["errors"]["product_type"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without at least one property value" do
      post :create, :product_type => product_type.id
      expected["errors"].delete("product_type")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with any invalid property values" do
      post :create, :product_type => product_type.id, :property_values => property_value.id.to_s + ",99"
      expected["errors"].delete("product_type")
      expected["errors"]["property_values"].push("must be all valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :product_type => product_type.id, :property_values => property_value.id.to_s
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Product.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Product, :count).by(1)
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Product.create( :product_type => product_type, :property_values => [ property_value ] )
      get :show, :id => 1
      response.should be_ok
    end
  end

  describe "PUT /:id" do
  
    let(:product) { Product.create( :product_type => product_type, :property_values => [ property_value ] ) }
  
    it "should not work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product" => "must be valid" } }
    end

    it "should work with a valid product_type" do
      put :update, :id => product.id, :product_type => another_product_type.id
      response.body.should == "OK"
      Product.find(product.id).product_type.should == another_product_type
    end

    it "shouldn't work with an invalid product_type" do
      put :update, :id => product.id, :product_type => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product_type" => "must be valid" } }
    end

    it "should work with a valid single property value" do
      put :update, :id => product.id, :property_values => [ another_property_value.id ]
      response.body.should == "OK"
      Product.find(product.id).property_values.should == [ another_property_value ]
    end
    
    it "should *add* the property values if it's a comma separated string" do
      put :update, :id => product.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s
      response.body.should == "OK"
      Product.find(product.id).property_values.should == [ property_value, another_property_value, a_third_property_value ]
    end

    it "shouldn't work with an invalid single property value" do
      put :update, :id => product.id, :property_values => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "must be all valid" } }
    end

    it "shouldn't work even if only one property value is invalid" do
      put :update, :id => product.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s + ",99"
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "must be all valid" } }
    end
    
    it "should work with a valid single property value and a product type" do
      put :update, :id => product.id, :property_values => [ another_property_value.id ], :product_type => product_type.id
      response.body.should == "OK"
      Product.find(product.id).product_type.should == product_type
      Product.find(product.id).property_values.should == [ another_property_value ]
    end
        
    it "should work with more than one valid property value" do
      put :update, :id => product.id, :property_values => [ another_property_value.id, a_third_property_value.id ]
      response.body.should == "OK"
      Product.find(product.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
    
    it "should work with more than one valid property value and a product type" do
      put :update, :id => product.id, :property_values => [ another_property_value.id, a_third_property_value.id ], :product_type => product_type.id
      response.body.should == "OK"
      Product.find(product.id).product_type.should == product_type
      Product.find(product.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
  end
  
  describe "DELETE /:id" do
    it "shouldn't work with an invalid id" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product" => "must be valid" } }
    end
  
    it "should work with a valid id" do
      Product.create( :product_type => product_type, :property_values => [ property_value ] )
      lambda do
        delete :destroy, :id => 1
        response.body.should == "OK"
      end.should change(Product, :count).by(-1)
    end
  end
  
  describe "SEARCH" do
    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :product_type => another_product_type.id
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "shouldn't work with an invalid product type" do
      get :search, :product_type => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "product_type" => "not found" } }
    end
    
    it "shouldn't work with invalid property values" do
      get :search, :property_values => [99, 100]
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "property_values" => "not found" } }
    end
    
    it "should work with just the product type" do
      Product.create( :product_type => another_product_type, :property_values => [ property_value ] )
      get :search, :product_type => another_product_type.id
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "active_in_countries"=>[], "property_values"=>[{"id"=>1, "value"=>"1", "property_id"=>1, "property_name"=>"watts"}], "product_type_id"=>1, "product_type_name"=>"Choker"}]
    end
    
    it "should work combining parameters" do
      Product.create( :product_type => another_product_type, :property_values => [ property_value ] )
      get :search, :product_type => another_product_type.id, :property_values => [ property_value.id ]
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "active_in_countries"=>[], "property_values"=>[{"id"=>1, "value"=>"1", "property_id"=>1, "property_name"=>"watts"}], "product_type_id"=>1, "product_type_name"=>"Choker"}]
    end
    
    it "should work with one property value" do
      Product.create( :product_type => another_product_type, :property_values => [ property_value ] )
      get :search, :property_values => property_value.id.to_s
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "active_in_countries"=>[], "property_values"=>[{"id"=>1, "value"=>"1", "property_id"=>1, "property_name"=>"watts"}], "product_type_id"=>1, "product_type_name"=>"Choker"}]
    end
    
    it "should work with more than one property value" do
      Product.create( :product_type => another_product_type, :property_values => [ property_value, another_property_value ] )
      get :search, :property_values => [ property_value, another_property_value ]
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "active_in_countries"=>[], "property_values"=>[{"id"=>1, "value"=>"1", "property_id"=>1, "property_name"=>"watts"}, {"id"=>2, "value"=>"2", "property_id"=>1, "property_name"=>"watts"}], "product_type_id"=>1, "product_type_name"=>"Choker"}]
    end    
  end
end
