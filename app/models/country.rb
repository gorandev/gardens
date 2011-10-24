# == Schema Information
# Schema version: 20110513000634
#
# Table name: countries
#
#  id                  :integer         not null, primary key
#  iso_code            :string(255)
#  name                :string(255)
#  status              :string(255)
#  locale              :string(255)
#  decimal_separator   :string(255)
#  thousands_separator :string(255)
#  time_zone           :string(255)
#  currency_id         :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Country < ActiveRecord::Base
  belongs_to :currency
  
  has_many :retailers
  has_many :media_channels
  validates_presence_of :name, :iso_code, :locale, :time_zone, :currency  
end