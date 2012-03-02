# == Schema Information
#
# Table name: property_values
#
#  id          :integer         not null, primary key
#  value       :string(255)
#  property_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  word_id     :integer
#

require 'spec_helper'

describe PropertyValue do

  context "it should ask for all required fields" do
    let(:property_value) { PropertyValue.new }
    let(:product_type) { ProductType.create(:name => 'Squeezer') }
    let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
    
    it "shouldn't be valid with no fields" do
      property_value.should_not be_valid
    end
      
    it "shouldn't be valid with only the property type" do
      property_value.property = property
      property_value.should_not be_valid
    end
    
    it "should be valid with the property type and the value" do
      property_value.property = property
      property_value.value = 1
      property_value.should be_valid
    end
  end

end



