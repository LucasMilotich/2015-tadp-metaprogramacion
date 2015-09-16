module Transformaciones

  def inject(&bloque)

  end

  def redirect_to(objetonuevo)
    proc{|el_metodo, *args| el_metodo.owner.define_method(el_metodo.name) do objetonuevo.method(el_metodo.name).call(args) end}
  end

  def before (&bloque)

  end

  def after (&bloque)

  end

  def instead_of (&bloque)

  end

end