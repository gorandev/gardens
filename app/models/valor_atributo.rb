class ValorAtributo < ActiveRecord::Base
  attr_accessible :descripcion
  belongs_to  :atributo
end
