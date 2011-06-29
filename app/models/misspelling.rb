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

class Misspelling < ActiveRecord::Base
  belongs_to :word
  validates_presence_of :value, :word
end