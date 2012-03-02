# == Schema Information
#
# Table name: sales
#
#  id               :integer         not null, primary key
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
#

require 'spec_helper'

describe Sale do
  pending "add some examples to (or delete) #{__FILE__}"
end

