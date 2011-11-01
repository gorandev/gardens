require 'spec_helper'

describe MediaChannelsController do

  let(:expected) {
    { "errors" => {
      "name" => [ "can't be blank" ],
      "country" => [ "can't be blank if retailer is blank" ],
      "retailer" => [ "can't be blank if country is blank" ],
      "media_channel_type" => [ "can't be blank" ]
      }
    }
  }

  let (:currency) { Currency.create(:name => 'Felicidon', :symbol => 'F') }
  let (:country) { Country.create(
    :name => 'Felicidonia',
    :iso_code => 'FD',
    :locale => 'es_FD',
    :time_zone => 'GMT-03:00',
    :currency => currency
  ) }
  let (:retailer) { Retailer.create( :name => 'Falarino', :country => country, :color => '#FFFFFF' ) }
  let (:media_channel_type) { MediaChannelType.create(:name => 'Diario') }

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
      expected["errors"].delete("name")
      expected["errors"].delete("media_channel_type")
  		ActiveSupport::JSON.decode(response.body).should == expected
  	end

    it "shouldn't work without name" do
    	post :create, :country => country.id, :media_channel_type => media_channel_type.id
    	expected["errors"].delete("country")
      expected["errors"].delete("retailer")
    	expected["errors"].delete("media_channel_type")
    	ActiveSupport::JSON.decode(response.body).should == expected    	
    end

    it "shouldn't work without country nor retailer" do
  		post :create, :name => 'Whatever', :media_channel_type => media_channel_type.id
  		expected["errors"].delete("name")
  		expected["errors"].delete("media_channel_type")
  		ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid country" do
  		post :create, :name => 'Whatever', :media_channel_type => media_channel_type.id, :country => 99
  		expected["errors"].delete("name")
  		expected["errors"].delete("media_channel_type")
  		ActiveSupport::JSON.decode(response.body).should == expected
    end
    
    it "shouldn't work with an invalid country" do
      post :create, :name => 'Whatever', :media_channel_type => media_channel_type.id, :retailer => 99
      expected["errors"].delete("name")
      expected["errors"].delete("media_channel_type")
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work without a media channel type" do
  		post :create, :name => 'Whatever', :country => country.id
  		expected["errors"].delete("name")
  		expected["errors"].delete("country")
      expected["errors"].delete("retailer")
  		ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with an invalid media channel type" do
  		post :create, :name => 'Whatever', :media_channel_type => 99, :country => country.id
  		expected["errors"].delete("name")
  		expected["errors"].delete("country")
      expected["errors"].delete("retailer")
  		expected["errors"]["media_channel_type"].push("must be valid")
  		ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "shouldn't work with both a country and a retailer" do
      post :create, :name => 'Whatever', :country => country.id, :media_channel_type => media_channel_type.id, :retailer => retailer.id
      expected["errors"].delete("name")
      expected["errors"].delete("media_channel_type")
      expected["errors"]["country"][0] = "can't be set if retailer isn't blank"
      expected["errors"]["retailer"][0] = "can't be set if country isn't blank"
      ActiveSupport::JSON.decode(response.body).should == expected
    end

    it "should work with all required values" do
  		lambda do
        post :create, :name => 'Whatever', :country => country.id, :media_channel_type => media_channel_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        MediaChannel.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
  		end.should change(MediaChannel, :count).by(1)
      lambda do
        post :create, :name => 'Whatever', :retailer => retailer.id, :media_channel_type => media_channel_type.id
        response.should be_ok
        ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
        MediaChannel.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
      end.should change(MediaChannel, :count).by(1)
    end
  end
end
