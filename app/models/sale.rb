# == Schema Information
#
# Table name: sales
#
#  id               :integer          not null, primary key
#  sale_date        :date
#  price            :integer
#  origin           :string(255)
#  units_available  :integer
#  valid_since      :date
#  valid_until      :date
#  bundle           :boolean
#  deleted          :boolean
#  media_channel_id :integer
#  retailer_id      :integer
#  product_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#  page             :integer
#  currency_id      :integer
#  imagen_id        :integer
#  aws_filename     :string(255)
#

class Sale < ActiveRecord::Base
	belongs_to :media_channel
	belongs_to :retailer
	belongs_to :product
	belongs_to :currency

	validates :price, :numericality => { :only_integer => true }
	validates :page, :numericality => { :only_integer => true }
	validates :units_available, :numericality => { :only_integer => true }, :allow_nil => true
	validates_presence_of :sale_date, :media_channel, :retailer, :product, :currency, :price, :page
end

