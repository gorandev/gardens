# == Schema Information
#
# Table name: rule_types
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe RuleType do
  
	context "it should ask for all required fields" do
	    let(:ruletype) { RuleType.new }

		it "shouldn't be valid with no fields" do
			ruletype.should_not be_valid
	    end

	    it "should be valid with the description" do
	    	ruletype.description = 'Test'
	    	ruletype.should be_valid
	    end
	end

end
