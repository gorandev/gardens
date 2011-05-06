# == Schema Information
# Schema version: 20110506175913
#
# Table name: tipo_productos
#
#  id          :integer         not null, primary key
#  descripcion :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class TipoProducto < ActiveRecord::Base
  attr_accessible :descripcion
  has_one :atributo
  
  validates :descripcion, :presence => true
  validates_associated :atributo
end
