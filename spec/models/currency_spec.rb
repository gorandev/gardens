# == Schema Information
#
# Table name: currencies
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  symbol         :string(255)
#  decimal_places :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe Currency do
  
  context "it should ask for all required fields" do
  
    let(:currency) { Currency.new }
    
    it "shouldn't be valid with no fields" do
      currency.should_not be_valid
    end
      
    it "shouldn't be valid with only the name" do
      currency.name = 'Felicidon'
      currency.should_not be_valid
    end
    
    it "should be valid with name and symbol" do
      currency.name = 'Felicidon'
      currency.symbol = 'F'
      currency.should be_valid
    end

  end
  
end


