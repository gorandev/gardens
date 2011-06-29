require 'spec_helper'

describe ProductType do
  
  context "it should ask for all required fields" do
    let(:product_type) { ProductType.new }
    
    it "shouldn't be valid with no fields" do
      product_type.should_not be_valid
    end
      
    it "should be valid with only the name" do
      product_type.name = 'Squeezers'
      product_type.should be_valid
    end
  end
  
end

# == Schema Information
#
# Table name: product_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

