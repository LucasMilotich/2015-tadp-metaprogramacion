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
    _owner = self.metodo.owner
    _parametersMethod = self.metodo.paramers.map { |arg| arg[1].to_s }
    




    _owner.send(:define_method,self.metodo.name) {

    #una vez filtrado los parametros a utilizar, agregarlos a call

=begin
      => :hola
      [49] pry(main)> send(:define_method,:hola) do
        [49] pry(main)*   |arg1,arg2|
            [49] pry(main)*   arg1= 2
        [49] pry(main)*   metodoCopia.call(arg1,arg2)
        [49] pry(main)* end
      => :hola
      [50] pry(main)> method(:hola).call(1,2)
      2
      2
      =>
=end

    _clonedMethod.call()
    }

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