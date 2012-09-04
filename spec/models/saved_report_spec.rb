# == Schema Information
#
# Table name: saved_reports
#
#  id              :integer          not null, primary key
#  querystring     :text
#  orden           :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  url             :text
#  product_type_id :integer
#

require 'spec_helper'

describe SavedReport do
  pending "add some examples to (or delete) #{__FILE__}"
end


