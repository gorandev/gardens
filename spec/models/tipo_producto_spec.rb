require 'spec_helper'

describe TipoProducto do
  
  before(:each) do
    @attr = { :descripcion => "Ejemplo" }
  end
  
  it "deberia crear un Tipo de Producto" do
    TipoProducto.create!(@attr)
  end
   
  it "deberia requerir la descripcion" do
    tp_sin_descripcion = TipoProducto.new
    tp_sin_descripcion.should_not be_valid
  end
  
end
