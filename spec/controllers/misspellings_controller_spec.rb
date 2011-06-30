require 'spec_helper'

describe MisspellingsController do
  let(:expected) {
    { "errors" => {
      "value" => [ "can't be blank" ],
      "word" => [ "can't be blank" ]
      }
    }
  }

  let(:word) { Word.create(:value => 'NIRVANA') }
  let(:another_word) { Word.create(:value => 'OFFSPRING') }

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

    it "shouldn't work without word" do
      post :create, :value => 'SATORI'
      expected["errors"].delete("value")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with an invalid word" do
      post :create, :value => 'SATORI', :word => 99
      expected["errors"].delete("value")
      expected["errors"]["word"].push("must be valid")
      ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "should work with all required values" do
      lambda do
        post :create, :value => 'SATORI', :word => word.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        Misspelling.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(Misspelling, :count).by(1)
    end
    
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Misspelling.create(:value => 'SATORI', :word => word)
      get :show, :id => 1
      response.should be_ok
    end
  end

  describe "DELETE /:id" do
    it "shouldn't work with an invalid id" do
      delete :destroy, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "misspelling" => "must be valid" } }
    end
  
    it "should work with a valid id" do
      Misspelling.create(:value => 'SATORI', :word => word)
      lambda do
        delete :destroy, :id => 1
        response.body.should == "OK"
      end.should change(Misspelling, :count).by(-1)
    end
  end
  
  describe "PUT /:id" do  
    let(:misspelling) {
      misspelling = Misspelling.create(:value => 'SATORI', :word => word)
    }
  
    it "shouldn't work with an invalid id" do
      put :update, :id => 99
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "misspelling" => "must be valid" } }
    end
    
    it "shouldn't work without nothing apart from the id" do
      put :update, :id => misspelling.id
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "misspelling" => "nothing to update" } }
    end
    
    it "should work with any single attribute" do
      put :update, :id => misspelling.id, :value => "SUFANA"
      response.body.should == "OK"
      Misspelling.find(misspelling.id).value.should == "SUFANA"
      
      put :update, :id => misspelling.id, :word => another_word
      response.body.should == "OK"
      Misspelling.find(misspelling.id).word.should == another_word
    end    
    
    it "should work with all attributes" do
      put :update, :id => misspelling.id, :value => "SUFANA", :word => another_word
      response.body.should == "OK"
      Misspelling.find(misspelling.id).value.should == "SUFANA"
      Misspelling.find(misspelling.id).word.should == another_word
    end
  end
  
  describe "SEARCH" do
    before(:each) do
      Misspelling.create(:value => 'SATORI', :word => word)
    end

    it "shouldn't work without parameters" do
      get :search
      ActiveSupport::JSON.decode(response.body).should == { "errors" => { "misspelling" => "no search parameters" } }
    end
    
    it "should work even with no results" do
      get :search, :value => "XXX"
      ActiveSupport::JSON.decode(response.body).should == []
    end
    
    it "should work with any single parameter" do
      get :search, :value => 'SATORI'
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "value"=>"SATORI", "word_id"=>1, "word_value"=>"NIRVANA"}]
      get :search, :word => word.value
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "value"=>"SATORI", "word_id"=>1, "word_value"=>"NIRVANA"}]
    end
    
    it "should work with more than one parameter" do
      get :search, :value => 'SATORI', :word => word.value
      ActiveSupport::JSON.decode(response.body).should == [{"id"=>1, "value"=>"SATORI", "word_id"=>1, "word_value"=>"NIRVANA"}]
    end
  end
end
