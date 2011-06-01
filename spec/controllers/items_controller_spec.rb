require 'spec_helper'

describe ItemsController do

  let(:expected) {
    { "errors" => {
      "retailer" => [ "can't be blank" ],
      "property_values" => [ "can't be blank" ]
      }
    }
  }

  let(:product_type) { ProductType.create(:name => 'Squeezer') }
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
  let(:item) { Item.create(:retailer => retailer, :property_values => [ property_value ]) }
  
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
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work without at least one property value" do
      post :create, :retailer => retailer.id
      expected["errors"].delete("retailer")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with invalid property values" do
      post :create, :retailer => retailer.id, :property_values => "99,100,102"
      expected["errors"].delete("retailer")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work without product and a single property value" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s
        response.body.should == "OK"
      end.should change(Item, :count).by(1)
      Item.last.retailer.should == retailer
      Item.last.property_values.should == [ property_value ]
    end
    
    it "should work without product and more than one property value via comma separated string" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s + ',' + another_property_value.id.to_s
        response.body.should == "OK"
      end.should change(Item, :count).by(1)
      Item.last.retailer.should == retailer
      Item.last.property_values.should == [ property_value, another_property_value ]
    end    
    
    it "should work without product and more than one property value via array of ids" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => [ property_value.id, another_property_value.id ]
        response.body.should == "OK"
      end.should change(Item, :count).by(1)
      Item.last.retailer.should == retailer
      Item.last.property_values.should == [ property_value, another_property_value ]
    end
    
    it "should work with product and a single property value" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :product => product.id
        response.body.should == "OK"
        Item.last.retailer.should == retailer
        Item.last.product.should == product
      end.should change(Item, :count).by(1)
    end

    it "should work with product and more than one property value via comma separated string" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s + ',' + another_property_value.id.to_s, :product => product.id
        response.body.should == "OK"
      end.should change(Item, :count).by(1)
      Item.last.retailer.should == retailer
      Item.last.product.should == product
      Item.last.property_values.should == [ property_value, another_property_value ]
    end    
    
    it "should work with product and more than one property value via array of ids" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => [ property_value.id, another_property_value.id ], :product => product.id
        response.body.should == "OK"
      end.should change(Item, :count).by(1)
      Item.last.retailer.should == retailer
      Item.last.product.should == product
      Item.last.property_values.should == [ property_value, another_property_value ]
    end
    
    it "should work even with an invalid product (it's ignored)" do
      lambda do
        post :create, :retailer => retailer.id, :property_values => property_value.id.to_s, :product => 99
        response.body.should == "OK"
      end.should change(Item, :count).by(1)
      Item.last.retailer.should == retailer
      Item.last.property_values.should == [ property_value ]
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Item.create(:retailer => retailer, :product => product, :property_values => [ property_value ])
      get :show, :id => 1
      response.should be_ok
    end
  end
  
  describe "DELETE /:id" do
    it "shouldn't work with a nonexistent item" do
      delete :destroy, :id => 99
      response.body.should == "ERROR: no valid item id"
    end
  
    it "should work" do
      Item.create(:retailer => retailer, :product => product, :property_values => [ property_value ])
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

    it "should work with a valid product" do
      put :update, :id => item.id, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).product.should == product
    end
    
    it "should work with a retailer *and* a product" do
      put :update, :id => item.id, :product => product.id, :retailer => another_retailer.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).product.should == product
    end

    it "should work with a valid single property value" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s
      response.body.should == "OK"
      Item.find(item.id).property_values.should == [ another_property_value ]
    end

    it "should work with a valid single property value and a retailer" do
      put :update, :id => item.id, :retailer => another_retailer.id, :property_values => another_property_value.id.to_s
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).property_values.should == [ another_property_value ]
    end
    
    it "should work with a valid single property value and a product" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value ]
    end
    
    it "should work with a valid single property value and a retailer *and* a product" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s, :retailer => another_retailer.id, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value ]
    end
    
    it "should work with more than one valid property value" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s
      response.body.should == "OK"
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
    
    it "should work with more than one valid property value and a retailer" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s, :retailer => another_retailer.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
    
    it "should work with more than one valid property value and a product" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
    
    it "should work with more than one valid property value and a retailer *and* a product" do
      put :update, :id => item.id, :property_values => another_property_value.id.to_s + "," + a_third_property_value.id.to_s, :retailer => another_retailer.id, :product => product.id
      response.body.should == "OK"
      Item.find(item.id).retailer.should == another_retailer
      Item.find(item.id).product.should == product
      Item.find(item.id).property_values.should == [ another_property_value, a_third_property_value ]
    end
  end  
end