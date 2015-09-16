module Transformaciones

  def inject(&bloque)

  end

  def redirect_to(objetonuevo)
    clase_origen.send(:define_method, @metodo_a_transformar.name)do objetonuevo.method(el_metodo.name).call(args) end
  end

  def before (&bloque)

  end

  def after (&bloque)

  end

  def instead_of (&bloque)
    clase_origen.send(:define_method, @metodo_a_transformar.name, bloque)
  end

end