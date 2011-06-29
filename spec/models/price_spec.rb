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

    it "should be valid with item, currency and price" do
      price.item = item
      price.currency = currency
      price.price = 1
      price.should be_valid
    end
    
  end
  
end

# == Schema Information
#
# Table name: prices
#
#  id          :integer         not null, primary key
#  item_id     :integer
#  price_date  :datetime
#  currency_id :integer
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

