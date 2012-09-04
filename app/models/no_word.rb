# == Schema Information
#
# Table name: no_words
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class NoWord < ActiveRecord::Base
  validates_presence_of :value
  validates_uniqueness_of :value, :case_sensitive => false
end

