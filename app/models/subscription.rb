# == Schema Information
#
# Table name: subscriptions
#
#  id              :integer         not null, primary key
#  product_type_id :integer
#  country_id      :integer
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Subscription < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :country
  belongs_to :user
  attr_accessible :id, :country, :product_type, :user
  validates :product_type_id, :country_id, :user_id, :presence => true
end
