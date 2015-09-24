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

    _duenio = get_duenio(@metodo)
    _clase = self.obtenerClase(_duenio)
    _metodo_a_llamar = _duenio.is_a?(Class) ? :define_method : :define_singleton_method
     _nombre = self.metodo.name

     _metodoOriginal = ("original" + _nombre.to_s).to_sym

      if !_clase.instance_methods().include?(_metodoOriginal)
        _clase.class_exec{alias_method _metodoOriginal, _nombre}
      end

    _duenio.send(_metodo_a_llamar,self.metodo.name) {
        |*args|

      _parametersMethod = method(_metodoOriginal).parameters.map{|x| x[1] }
      _parametersMethod.select { |param|

       if hash[param] != nil
         _n = _parametersMethod.index(param)
         args[_n] = hash[param].is_a?(Proc) ? hash[param].call(_duenio,__method__,args[_n-1]) : hash[param]
       end
                            }

      _duenio.is_a?(Class) ? _duenio.instance_method(_metodoOriginal).bind(self).call(*args) : _duenio.send(_metodoOriginal,*args)


      #_meth =  _clonedMethod
      #_meth.call(*args)

    }


  end
  def obtenerClase(duenio)
    duenio.is_a?(Class) ? duenio : duenio.class
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
    proc_contexto = proc{|instance,contexto,*args| old_method.bind(instance).call *args}
    modificar do |*args|
      self.instance_exec(self,proc_contexto,*args, &bloque)
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