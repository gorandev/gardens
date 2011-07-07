xml.instruct!
xml.atributos do
  @a.each do |atributo|
    xml.atributo do
      xml.tipo_producto_id atributo.tipo_producto.id
      xml.tipo_producto_descripcion atributo.tipo_producto.descripcion
      xml.id atributo.id
      xml.descripcion atributo.descripcion
      xml.valor_atributos do
        atributo.valor_atributos.each do |valor|
          xml.valor do
            xml.id valor.id
            xml.descripcion valor.descripcion
          end
        end
      end
    end
  end
end