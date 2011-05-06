require 'spec_helper'

describe Atributo do

  before(:each) do
    @attr = { :descripcion => "Ejemplo" }
  end
  
  it "deberia crear un Atributo" do
    Atributo.create!(@attr)
  end
   
  it "deberia requerir la descripcion" do
    atributo_sin_descripcion = Atributo.new
    atributo_sin_descripcion.should_not be_valid
  end

end
