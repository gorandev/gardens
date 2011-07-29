# == Schema Information
#
# Table name: items
#
#  id              :integer         not null, primary key
#  product_id      :integer
#  retailer_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  source          :string(255)
#  product_type_id :integer
#  imagen_id       :integer
#  url             :string(255)
#  description     :text(255)
#

class Item < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_type
  belongs_to :retailer
  
  has_and_belongs_to_many :property_values
  has_many :prices
  
  validates_presence_of :retailer, :product_type, :source
  validates_inclusion_of :source, :in => %w(web papel)
  validates_url_format_of :url, :allow_nil => true
  validates_uniqueness_of :url, :allow_nil => true
end