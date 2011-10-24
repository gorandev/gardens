# == Schema Information
#
# Table name: media_channels
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  media_channel_type_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

describe MediaChannel do
  pending "add some examples to (or delete) #{__FILE__}"
end
