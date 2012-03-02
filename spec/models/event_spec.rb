# == Schema Information
#
# Table name: events
#
#  id           :integer         not null, primary key
#  item_id      :integer
#  precio_viejo :integer
#  precio_nuevo :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Event do
  let(:event) { Event.new }
  
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
  
  it "shouldn't be valid with no fields" do
    event.should_not be_valid
  end

  it "shouldn't be valid without an item" do
    event.precio_viejo = 100
    event.precio_nuevo = 200
    event.should_not be_valid
  end
  
  it "shouldn't be valid without precio_viejo" do
    event.item = item
    event.precio_nuevo = 200
    event.should_not be_valid
  end
  
  it "shouldn't be valid without precio_nuevo" do
    event.item = item
    event.precio_viejo = 100
    event.should_not be_valid
  end
  
  it "should be valid with all required fields" do
    event.item = item
    event.precio_viejo = 100
    event.precio_nuevo = 200
    event.should be_valid
  end
end

