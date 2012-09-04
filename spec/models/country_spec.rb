# == Schema Information
#
# Table name: countries
#
#  id                  :integer          not null, primary key
#  iso_code            :string(255)
#  name                :string(255)
#  status              :string(255)
#  locale              :string(255)
#  decimal_separator   :string(255)
#  thousands_separator :string(255)
#  time_zone           :string(255)
#  currency_id         :integer
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe Country do
  
  context "it should ask for all required fields" do
  
    let(:country) { Country.new }
  
    it "shouldn't be valid with no fields" do
      country.should_not be_valid
    end
      
    it "shouldn't be valid with only the name" do
      country.name = 'Felicidonia'
      country.should_not be_valid
    end
    
    it "shouldn't be valid with name and iso_code only" do
      country.name = 'Felicidonia'
      country.iso_code = 'FD'
      country.should_not be_valid
    end
    
    it "shouldn't be valid with name, iso_code and locale only" do
      country.name = 'Felicidonia'
      country.iso_code = 'FD'
      country.locale = 'es_FD'
      country.should_not be_valid
    end

    it "shouldn't be valid with name, iso_code, locale and time_zone only" do
      country.name = 'Felicidonia'
      country.iso_code = 'FD'
      country.locale = 'es_FD'
      country.time_zone = 'GMT-03:00'
      country.should_not be_valid
    end
    
    it "should be valid with all set" do
      country.name = 'Felicidonia'
      country.iso_code = 'FD'
      country.locale = 'es_FD'
      country.time_zone = 'GMT-03:00'
      country.currency = Currency.create(:name => 'Felicidon', :symbol => 'F')
      country.should be_valid
    end
    
  end
  
end


