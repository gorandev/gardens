require 'spec_helper'
include Devise::TestHelpers
describe SavedReportsController do

  let(:expected) {
    { "errors" => {
      "querystring" => [ "can't be blank" ]
      }
    }
  }

  before(:each) do
    request.env['HTTP_ACCEPT'] = "application/json"
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = Factory(:user)
    sign_in @user
  end

  describe "POST 'create'" do
    it "shouldn't work without querystring" do
      post :create
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "should work with the querystring" do
      lambda do
        post :create, :querystring => 'gabba gabba hey'
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        SavedReport.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(SavedReport, :count).by(1)
    end
  end

end
