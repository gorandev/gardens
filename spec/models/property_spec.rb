require 'spec_helper'

describe Property do

  context "it should ask for all required fields" do
    let(:property) { Property.new }
    let(:product_type) { ProductType.create(:name => 'Squeezer') }
    
    it "shouldn't be valid with no fields" do
      property.should_not be_valid
    end
      
    it "shouldn't be valid with only the name" do
      property.name = "Tonnage"
      property.should_not be_valid
    end
    
    it "should be valid with the property name and the product type" do
      property.name = "Tonnage"
      property.product_type = product_type
      property.should be_valid
    end
  end

end
