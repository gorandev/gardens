# == Schema Information
#
# Table name: retailers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#  color      :string(255)
#
require 'spec_helper'

describe Retailer do

  context "it should ask for all required fields" do
    let(:retailer) { Retailer.new }
    
    it "shouldn't be valid with no fields" do
      retailer.should_not be_valid
    end
      
    it "shouldn't be valid with only the name" do
      retailer.name = 'Falarino'
      retailer.should_not be_valid
    end
    
    it "should be valid with name, color and country" do
      retailer.name = 'Falarino'
      retailer.color = '#FFFFFF'
      
      country = Country.new
      country.name = 'Felicidonia'
      country.iso_code = 'FD'
      country.locale = 'es_FD'
      country.time_zone = 'GMT-03:00'
      country.currency = Currency.create(:name => 'Felicidon', :symbol => 'F')
      
      retailer.country = country
      retailer.should be_valid
    end
  end

end