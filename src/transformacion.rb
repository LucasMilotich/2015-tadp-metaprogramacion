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

  def inject (hash)
    _duenio = clase_metodo
    _nombre = self.metodo.name
    _nombreOriginal = ("original_" + _nombre.to_s).to_sym
    clase_metodo.class_exec {alias_method _nombreOriginal, _nombre} if !clase_metodo.instance_methods.include?(_nombreOriginal)

    modificar do |*args|
      _parametersMethod = method(_nombreOriginal).parameters.map(&:last)
      _parametersMethod.select { |param|
        if !hash[param].nil?
          _n = _parametersMethod.index(param)
          args[_n] = hash[param].is_a?(Proc) ? hash[param].call(_duenio,_nombre,args[_n-1]) : hash[param]
        end
      }
      _duenio.instance_method(_nombreOriginal).bind(self).call(*args)
    end

  end

  def redirect_to(objetonuevo)
    nuevo = objetonuevo.method(self.metodo.name)
    modificar do
    |args| nuevo.call(args)
    end
  end

  def before (&bloque)
    old_method = self.metodo
    proc_contexto = proc{|instance,contexto,*args| old_method.bind(instance).call *args}
    modificar do |*args|
      self.instance_exec(self,proc_contexto,*args, &bloque)
    end

  end

  def after(&bloque)
    old_method = self.metodo
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

end