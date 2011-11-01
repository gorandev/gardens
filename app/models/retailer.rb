# == Schema Information
#
# Table name: retailers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#  color      :string(255)
#

class Retailer < ActiveRecord::Base
  belongs_to :country
  has_many :items
  has_many :products, :through => :items
  has_many :sales
  has_many :media_channels
  
  validates_presence_of :name, :country, :color
end
