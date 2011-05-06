class TipoProducto < ActiveRecord::Base
  attr_accessible :descripcion
  has_one :atributo
end
