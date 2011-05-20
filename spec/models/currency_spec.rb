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
