# == Schema Information
#
# Table name: subscriptions
#
#  id              :integer          not null, primary key
#  product_type_id :integer
#  country_id      :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Subscription do
  pending "add some examples to (or delete) #{__FILE__}"
end
