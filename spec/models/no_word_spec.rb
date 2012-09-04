# == Schema Information
#
# Table name: no_words
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe NoWord do
  let(:no_word) { NoWord.new }
  
  it "shouldn't be valid with no fields" do
    no_word.should_not be_valid
  end
  
  it "should be valid with a value" do
    no_word.value = 'Nirvana'
    no_word.should be_valid
  end
end
