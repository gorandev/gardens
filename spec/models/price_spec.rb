# == Schema Information
#
# Table name: prices
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  price_date  :date
#  currency_id :integer
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Price do

  context "it should ask for all required fields" do
  
    let(:product_type) { ProductType.create(:name => 'Squeezer') }
    let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
    let(:property_value) { PropertyValue.create(:value => 1, :property => property) }
  
    let(:item) { 
      Item.create(
        :retailer => Retailer.create(
          :name => 'Falarino',
          :country => Country.create(
            :name => 'Felicidonia',
            :iso_code => 'FD',
            :locale => 'es_FD',
            :time_zone => 'GMT-03:00',
            :currency => Currency.create(:name => 'Felicidon', :symbol => 'F')
          )
        ),
        :property_values => [ property_value ]
      )
    }
    
    let(:currency) { Currency.create(:name => 'Felicidon', :symbol => 'F') }
    let(:price) { Price.new }
    
    it "shouldn't be valid with no fields" do
      price.should_not be_valid
    end
    
    it "shouldn't be valid with only the item" do
      price.item = item
      price.should_not be_valid
    end

    it "shouldn't be valid with only the item and the currency" do
      price.item = item
      price.currency = currency
      price.should_not be_valid
    end

    it "shouldn't be valid with everything except the date" do
      price.item = item
      price.currency = currency
      price.price = 1
      price.should_not be_valid
    end
    
    it "should be valid with item, currency, price and date" do
      price.item = item
      price.currency = currency
      price.price = 1
      price.price_date = Date.current
      price.should be_valid
    end
    
    it "shouldn't be valid to create a price for an existing date for an item" do
      price.item = item
      price.currency = currency
      price.price = 1
      price.price_date = Date.current
      price.save
      
      another_price = Price.new
      another_price.item = item
      another_price.currency = currency
      another_price.price = 1
      another_price.price_date = Date.current
      
      another_price.should_not be_valid
    end
    
  end
  
end

