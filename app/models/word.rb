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

class Word < ActiveRecord::Base
  has_many :property_values
  has_many :misspellings
  validates_format_of :value, :with => /\A[A-Z0-9\s()*.'"\/\+_-]+\z/i
  validates_uniqueness_of :value, :case_sensitive => false
end

