require 'spec_helper'

describe CountriesController do

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
      response.body.should == "ERROR: no name"
    end
    
    it "shouldn't work without iso code" do
      post :create, :name => 'Felicidonia'
      response.body.should == "ERROR: no iso_code"
    end
    
    it "shouldn't work without locale" do
      post :create, :name => 'Felicidonia', :iso_code => 'FD'
      response.body.should == "ERROR: no locale"
    end
    
    it "shouldn't work without time zone" do
      post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD'
      response.body.should == "ERROR: no time_zone"
    end
    
    it "shouldn't work without currency" do
      post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00'
      response.body.should == "ERROR: no currency"
    end
    
    it "should save a new country" do
      Currency.create(:name => 'FLD', :symbol => 'F$')
      post :create, :name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00', :currency => 1
      response.body.should == "OK"
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Country.create(:name => 'Felicidonia', :iso_code => 'FD', :locale => 'es_FD', :time_zone => 'GMT-03:00', :currency => Currency.create(:name => 'FLD', :symbol => 'F$'))
      get :show, :id => 1
      response.should be_ok
    end
  end
  
end
