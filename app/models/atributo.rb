# == Schema Information
# Schema version: 20110506175913
#
# Table name: atributos
#
#  id               :integer         not null, primary key
#  descripcion      :string(255)
#  tipo_producto_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Atributo < ActiveRecord::Base
  attr_accessible :descripcion
  belongs_to :tipo_producto
  has_many :valor_atributos
  
  validates :descripcion, :presence => true
  validates_associated :valor_atributos
end
