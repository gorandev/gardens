# == Schema Information
# Schema version: 20110506175913
#
# Table name: valor_atributos
#
#  id          :integer         not null, primary key
#  descripcion :string(255)
#  atributo_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class ValorAtributo < ActiveRecord::Base
  attr_accessible :descripcion
  belongs_to  :atributo
  
  validates :descripcion, :presence => true
end
