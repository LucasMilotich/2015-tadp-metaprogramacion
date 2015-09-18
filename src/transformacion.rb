class Transformacion
  attr_accessor :metodo

  def self.new(un_metodo)
    s = super()
    s.metodo = un_metodo
    return s
  end

  def modificar(&bloque)
    clase_metodo.send(:define_method, self.metodo.name, &bloque)
  end


  def inject(&bloque)

  end

  def redirect_to(objetonuevo)
    nuevo = objetonuevo.method(self.metodo.name)
    modificar do
    |args| nuevo.call(args)
    end
  end

  def before (&bloque)
    siguiente = self.metodo.name
    modificar do |args|
      bloque
      self.method(siguiente).call(args)
    end
  end

  def after (&bloque)
    anterior = self.metodo.name
    modificar do |args|
      self.method(anterior).call(args)
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