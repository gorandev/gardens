# == Schema Information
#
# Table name: products
#
#  id              :integer         not null, primary key
#  status          :string(255)
#  product_type_id :integer
#  show_on_search  :boolean
#  created_at      :datetime
#  updated_at      :datetime
#  imagen_id       :integer
#

require 'spec_helper'

describe Product do
  
  context "it should ask for all required fields" do
    let(:product) { Product.new }
    let(:product_type) { ProductType.create(:name => 'Squeezer') }
    let(:property) { Property.create(:name => 'watts', :product_type => product_type) }
    let(:property_value) { PropertyValue.create(:value => 1, :property => property) }
    
    it "shouldn't be valid with no fields" do
      product.should_not be_valid
    end
      
    it "shouldn't be valid with only the product type" do
      product.product_type = product_type
      product.should_not be_valid
    end
    
    it "should be valid with product type and at least one property value" do
      product.product_type = product_type
      product.property_values << property_value
      product.should be_valid
    end
  end
  
end


