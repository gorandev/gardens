# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  product_id      :integer
#  retailer_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  source          :string(255)
#  product_type_id :integer
#  imagen_id       :integer
#  url             :string(255)
#  description     :text
#  aws_filename    :string(255)
#  ignored         :boolean
#


require 'spec_helper'

describe Item do

  let(:item) { Item.new }
  
  let(:product) { Product.new }
  let(:product_type) { ProductType.create(:name => 'Squeezer') }
  let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
  let(:property_value) { PropertyValue.create(:value => 1, :property => property) }
      
  let(:retailer) {
    Retailer.create(
      :name => 'Falarino',
      :country => Country.create(
        :name => 'Felicidonia',
        :iso_code => 'FD',
        :locale => 'es_FD',
        :time_zone => 'GMT-03:00',
        :currency => Currency.create(:name => 'Felicidon', :symbol => 'F')
      )
    )
  }
  
  it "shouldn't be valid with no fields" do
    item.should_not be_valid
  end
    
  it "shouldn't be valid with only the retailer" do
    item.retailer = retailer
    item.should_not be_valid
  end
  
  it "shouldn't be valid without a product type" do
    item.retailer = retailer
    item.source = 'papel'
    item.property_values << property_value
    item.should_not be_valid
  end
    
  it "shouldn't be valid with an invalid url" do
    item.retailer = retailer
    item.source = 'web'
    item.property_values << property_value
    item.url = 'blah'
    item.should_not be_valid
  end
  
  it "should be valid with a source, a product type and no product nor property values" do
    item.retailer = retailer
    item.source = 'papel'
    item.product_type = product_type
    item.should be_valid
  end

  it "shouldn't be valid with a property value and an invalid source" do
    item.retailer = retailer
    item.source = 'blah'
    item.property_values << property_value
    item.should_not be_valid
  end
  
  it "should also be valid with a property value, a source and a product" do
    item.retailer = retailer
    item.source = 'papel'
    item.product = product
    item.property_values << property_value
    item.product_type = product_type
    item.should be_valid
  end

  it "should also be valid with a property value, a source, a product and a valid url" do
    item.retailer = retailer
    item.source = 'web'
    item.url = 'http://www.idashboard.com.ar'
    item.product = product
    item.property_values << property_value
    item.product_type = product_type
    item.should be_valid
  end
  
end

