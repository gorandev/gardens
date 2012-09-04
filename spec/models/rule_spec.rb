# == Schema Information
#
# Table name: rules
#
#  id           :integer          not null, primary key
#  alert_id     :integer
#  value        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  rule_type_id :integer
#

require 'spec_helper'

describe Rule do

	context "it should ask for all required fields" do
	    let(:ruletype) { RuleType.create(:description => 'Prueba') }
	    let(:alert) { Alert.create() }
	    let(:rule) { Rule.new }

		it "shouldn't be valid with no fields" do
			rule.should_not be_valid
	    end

	    it "shouldn't be valid only with the alert" do
	    	rule.alert = alert
	    	rule.should_not be_valid
	    	rule.alert = nil
	    end

	    it "shouldn't be valid only with the ruletype" do
	    	rule.rule_type = ruletype
	    	rule.should_not be_valid
	    	rule.rule_type = nil
	    end

	    it "should be valid with all fields" do
	    	rule.rule_type = ruletype
	    	rule.alert = alert
	    	rule.should be_valid
	    end
	end

end
