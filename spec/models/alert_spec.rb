# == Schema Information
#
# Table name: alerts
#
#  id              :integer         not null, primary key
#  event_id        :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  product_type_id :integer
#  country_id      :integer
#

require 'spec_helper'

describe Alert do
  pending "add some examples to (or delete) #{__FILE__}"
end
