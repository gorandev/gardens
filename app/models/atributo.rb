class Atributo < ActiveRecord::Base
  attr_accessible :descripcion
  belongs_to :tipo_producto
  has_many :valor_atributos
end
