require 'spec_helper'

describe SalesController do

	let(:expected) {
		{ "errors" => {
			"sale_date" => [ "can't be blank" ],
			"price" => [ "is not a number" ],
			"media_channel" => [ "can't be blank" ],
			"page" => [ "is not a number" ],
			"retailer" => [ "can't be blank" ],
			"product" => [ "can't be blank" ],
			"currency" => [ "can't be blank" ]
			}
		}
	}

	let(:currency) { Currency.create(:name => 'Felicidon', :symbol => 'F') }
	let(:country) { Country.create(
		:name => 'Felicidonia',
		:iso_code => 'FD',
		:locale => 'es_FD',
		:time_zone => 'GMT-03:00',
		:currency => currency
	) }
	let(:media_channel_type) { MediaChannelType.create(:name => 'Diario') }
	let(:media_channel) { MediaChannel.create(:name => 'La Narin', :country => country, :media_channel_type => media_channel_type ) }
	let(:retailer) { Retailer.create( :name => 'Falarino', :country => country, :color => '#FFFFFF' ) }

	let(:product_type) { ProductType.create(:name => 'Squeezer') }
	let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
	let(:property_value) { PropertyValue.create(:value => 1, :property => property) }
	let(:product) { Product.create(:product_type => product_type, :property_values => [ property_value ]) }

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
		it "shouldn't work with no values" do
			post :create
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with no sale_date" do
			post :create, :price => 99, :media_channel => media_channel.id, :page => 1, :retailer => retailer.id, 
				:product => product.id, :currency => currency.id
				expected["errors"].delete("price")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("page")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with an invalid sale_date" do
			post :create, :sale_date => "ceci n'est pas une date", :price => 99, :media_channel => media_channel.id, :page => 1, :retailer => retailer.id, 
				:product => product.id, :currency => currency.id
				expected["errors"].delete("price")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("page")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with no price" do
			post :create, :sale_date => Date.today, :media_channel => media_channel.id, :page => 1, :retailer => retailer.id, 
				:product => product.id, :currency => currency.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("page")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with an invalid price" do
			post :create, :sale_date => Date.today, :price => "ceci n'est pas une price", :media_channel => media_channel.id, :page => 1, :retailer => retailer.id, 
				:product => product.id, :currency => currency.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("page")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with no media channel" do
			post :create, :sale_date => Date.today, :price => 99, :page => 1, :retailer => retailer.id, 
				:product => product.id, :currency => currency.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with an invalid media channel" do
			post :create, :sale_date => Date.today, :price => 99, :media_channel => "ceci n'est pas une media channel",
				:page => 1, :retailer => retailer.id, 
				:product => product.id, :currency => currency.id
				expected["errors"]["media_channel"].push("must be valid")
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with no page" do
			post :create, :sale_date => Date.today, :price => 99, :media_channel => media_channel.id, 
				:retailer => retailer.id, :product => product.id, :currency => currency.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with an invalid page" do
			post :create, :sale_date => Date.today, :price => 99, :media_channel => media_channel.id,
				:page => 1, :retailer => retailer.id, :page => "ceci n'est pas une page",
				:product => product.id, :currency => currency.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with no retailer" do
			post :create, :sale_date => Date.today, :price => 99, :page => 1, :media_channel => media_channel.id, 
				:product => product.id, :currency => currency.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with an invalid retailer" do
			post :create, :sale_date => Date.today, :price => 99, :media_channel => media_channel.id,
				:page => 1, :retailer => "wut?", :product => product.id, :currency => currency.id
				expected["errors"]["retailer"].push("must be valid")
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("product")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end
		
		it "shouldn't work with no product" do
			post :create, :sale_date => Date.today, :price => 99, :page => 1, :retailer => retailer.id, 
				:media_channel => media_channel.id, :currency => currency.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("retailer")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with an invalid product" do
			post :create, :sale_date => Date.today, :price => 99, :media_channel => media_channel.id,
				:page => 1, :retailer => retailer.id, :product => "wut?", :currency => currency.id
				expected["errors"]["product"].push("must be valid")
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("retailer")
				expected["errors"].delete("currency")
			ActiveSupport::JSON.decode(response.body).should == expected
		end
		
		it "shouldn't work with no currency" do
			post :create, :sale_date => Date.today, :price => 99, :page => 1, :retailer => retailer.id, 
				:product => product.id, :media_channel => media_channel.id
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "shouldn't work with an invalid currency" do
			post :create, :sale_date => Date.today, :price => 99, :media_channel => media_channel.id,
				:page => 1, :retailer => retailer.id, :product => product.id, :currency => "wut?"
				expected["errors"]["currency"].push("must be valid")
				expected["errors"].delete("sale_date")
				expected["errors"].delete("price")
				expected["errors"].delete("page")
				expected["errors"].delete("media_channel")
				expected["errors"].delete("retailer")
				expected["errors"].delete("product")
			ActiveSupport::JSON.decode(response.body).should == expected
		end

		it "should work with all fields ok" do
			lambda do
				post :create, :sale_date => Date.today, :price => 99, :media_channel => media_channel.id,
				:page => 1, :retailer => retailer.id, :product => product.id, :currency => currency.id
				ActiveSupport::JSON.decode(response.body)["id"].to_s.should match /^\d+$/
				Sale.find(ActiveSupport::JSON.decode(response.body)["id"]).id.should == ActiveSupport::JSON.decode(response.body)["id"]
			end.should change(Sale, :count).by(1)
		end
	end
end