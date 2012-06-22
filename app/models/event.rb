# == Schema Information
#
# Table name: events
#
#  id           :integer         not null, primary key
#  item_id      :integer
#  precio_viejo :integer
#  precio_nuevo :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Event < ActiveRecord::Base
  belongs_to :item
  has_many :users, :foreign_key => "last_event_id", :inverse_of => :last_event
  validates_presence_of :item, :precio_viejo, :precio_nuevo
end

