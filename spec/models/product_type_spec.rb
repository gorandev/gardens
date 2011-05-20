require 'spec_helper'

describe ProductType do
  
  context "it should ask for all required fields" do
    let(:product_type) { ProductType.new }
    
    it "shouldn't be valid with no fields" do
      product_type.should_not be_valid
    end
      
    it "shouldn't be valid with only the property type" do
      product_type.name = 'Squeezers'
      product_type.should be_valid
    end
  end
  
end
