# coding: utf-8
require 'spec_helper'

describe Misspelling do

  context "it should ask for all required fields" do
    let(:misspelling) { Misspelling.new }
    let(:word) { Word.create(:value => 'Nirvana') }
    
    it "shouldn't be valid with no fields" do
      misspelling.should_not be_valid
    end
      
    it "shouldn't be valid with only the value" do
      misspelling.value = 'Satori'
      misspelling.should_not be_valid
    end
    
    it "should be valid with the value with accents name and the word" do
      misspelling.value = 'Bróngo'
      misspelling.word = word
      misspelling.should be_valid
    end
    
    it "should be valid with the property name and the product type" do
      misspelling.value = 'Satori'
      misspelling.word = word
      misspelling.should be_valid
    end
  end

end

# == Schema Information
#
# Table name: misspellings
#
#  id         :integer         not null, primary key
#  value      :string(255)
#  word_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

