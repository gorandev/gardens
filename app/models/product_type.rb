# == Schema Information
#
# Table name: product_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProductType < ActiveRecord::Base
  has_many :properties
  has_many :saved_reports
  has_many :alerts
  has_many :subscriptions
  validates_presence_of :name  
end

