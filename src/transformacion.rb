class Transformacion
  attr_accessor :metodo

  def self.new(un_metodo)
    s = super()
    s.metodo = un_metodo
    return s
  end

  def modificar(&bloque)
    clase_metodo.send(:define_method, self.metodo.name, bloque)
  end


  def inject(&bloque)

  end

  def redirect_to(objetonuevo)
    modificar do
    |*args| objetonuevo.method(metodo.name).call(args)
    end
  end

  def before (&bloque)

  end

  def after (&bloque)
    modificar do
      self.method(self.metodo.name).call(args)
      bloque
    end
  end

  def instead_of (&bloque)
    modificar &bloque
  end

  def clase_metodo
    if metodo.is_a?(Method)
      return metodo.receiver.singleton_class
    else
      return metodo.owner
    end
  end

end