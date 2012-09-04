# coding: utf-8
# == Schema Information
#
# Table name: words
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Word do  
  let(:word) { Word.new }
  
  it "shouldn't be valid with no fields" do
    word.should_not be_valid
  end

  it "shouldn't be valid with a value with accents" do
    word.value = 'Bríngo'
    word.should_not be_valid
  end
  
  it "should be valid with a value" do
    word.value = 'Nirvana'
    word.should be_valid
  end
end


