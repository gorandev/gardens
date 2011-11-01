require 'spec_helper'

describe MediaChannelTypesController do

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
  	it "shouldn't work without anything" do
  		post :create
  		ActiveSupport::JSON.decode(response.body).should == expected
  	end

    it "should work with all required values" do
  		lambda do
        post :create, :name => 'Whatever'
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        MediaChannelType.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
  		end.should change(MediaChannelType, :count).by(1)
    end
  end
end
