require 'spec_helper'

describe ValorAtributo do

  before(:each) do
    @attr = { :descripcion => "Ejemplo" }
  end
  
  it "deberia crear un Valor Atributo" do
    ValorAtributo.create!(@attr)
  end
   
  it "deberia requerir la descripcion" do
    valor_atributo_sin_descripcion = ValorAtributo.new
    valor_atributo_sin_descripcion.should_not be_valid
  end

end
