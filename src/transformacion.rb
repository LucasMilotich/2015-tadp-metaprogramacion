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



  def inject(hash)


    _clonedMethod = self.metodo.clone
    _parametersMethod = _clonedMethod.parameters.map { |x| x[1] }
    _duenio = get_duenio(@metodo)
    _metodo_a_llamar = _duenio.is_a?(Class) ? :define_method : :define_singleton_method

    _duenio.send(_metodo_a_llamar,self.metodo.name) {
        |*args|

      _parametersMethod.each { |param|

       if hash[param] != nil
         _n = _parametersMethod.index(param)
         args[_n] = hash[param].is_a?(Proc) ? hash[param].call(_duenio,_clonedMethod.name.to_s,args[_n-1]) : hash[param]
       end
                            }

      _duenio.is_a?(Class) ? _clonedMethod.bind(self).call(*args) : _clonedMethod.call(*args)


      #_meth =  _clonedMethod
      #_meth.call(*args)

    }


  end

  def get_duenio(metodo)
    begin
      metodo.receiver
    rescue
      metodo.owner
    end


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