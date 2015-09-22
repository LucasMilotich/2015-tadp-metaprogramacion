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

  def inject(hash_p)

  end

  def redirect_to(objetonuevo)
    nuevo = objetonuevo.method(self.metodo.name)
    modificar do
    |args| nuevo.call(args)
    end
  end

  def before (&bloque)
    old_method = unbind_if
    modificar do |*args|
      self.instance_eval &bloque
      old_method.bind(self).call *args, &bloque
    end

  end

  def after(&bloque)
    old_method = unbind_if
    modificar do |*args|
      old_method.bind(self).call *args
      self.instance_eval &bloque
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

  def unbind_if
    if self.metodo.is_a?(Method)
      return self.metodo.unbind
    else
      return self.metodo
    end
  end

end