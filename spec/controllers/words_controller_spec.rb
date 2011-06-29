# coding: utf-8
require 'spec_helper'

describe WordsController do
  let(:expected) {
    { "errors" => {
      "value" => [ "is invalid" ]
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
    it "shouldn't work without value" do
      post :create
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid value" do
      post :create, :value => "Bríngo"
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with value" do
      lambda do
        post :create, :value => "Nirvana"
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Word.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Word, :count).by(1)
    end    
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Word.create(:value => 'Nirvana')
      get :show, :id => 1
      response.should be_ok
    end
  end
  
  describe "DELETE /:id" do
    it "shouldn't work with a nonexistent item" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "word" => "must be valid" } }
    end
  
    it "should work with an existing id" do
      w = Word.create(:value => 'Nirvana')
      lambda do
        delete :destroy, :id => w.id
        response.body.should == "OK"
      end.should change(Word, :count).by(-1)
    end
  end
  
  describe "SEARCH" do
    before(:each) do
      Word.create(:value => 'Nirvana')
    end
    
    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "word" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :value => "XXX"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with the value parameter" do
      get :search, :value => "Nirvana"
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "value"=>"Nirvana"}]
    end
  end
end