require_relative 'origen.rb'

class Aspects

  def self.on(origen_arg,*origenes_argumento,&bloque)
    _argumentos = []
    _argumentos << origen_arg
    _argumentos << origenes_argumento

    origenes_posta = []

    raise ArgumentError, "Sin bloque" if !block_given?

    _argumentos.each do |argumento|
      puts argumento
      if es_ER?(argumento)
        buscar_y_agregar(argumento, origenes_posta)
      else
        if existe_tipo?(argumento, Module) || existe_tipo?(argumento, Object) || existe_tipo?(argumento,Class)
          origenes_posta << Origen.new(argumento)
        end
        #if aspect.existe_clase?(argumento)
        #  aspect.origenes << argumento
        #else if aspect.existe_modulo?(argumento)
        #       aspect.origenes << argumento
        #     end
        #end
      end
    end

    raise ArgumentError, "Origen vacio" if origenes_posta.empty?

    origenes_posta.each do
      |origen| origen.instance_eval(&bloque)
    end
    #class_exec(&bloque)
    #return aspect
  end

  def self.existe_tipo?(argumento, tipo)
    ObjectSpace.each_object(tipo).to_a.include?(argumento)
  rescue
    false
  end

  def self.es_ER?(argumento)
    argumento.is_a?(Regexp)
  end

  def self.buscar_y_agregar(regex, lista_origenes)
     _lista = Object.constants.grep(regex).map {|regex_symbol| Object.const_get(regex_symbol)}
     if !lista.empty?
       _lista.each do |object|
         lista_origenes << Origen.new(object)
       end
     end
  end

  ###########################################################
  def self.where(condiciones)

    _listaSym = []
    _listaMetodos = []

    @origenes.each do |origen|

      if origen.is_a?(Class)
        #es una clase

        _listSym = origen.private_instance_methods(false).concat(origen.instance_methods(false))
        _listaSym.each do |sym|
        _listaMetodos <<  origen.new.method(sym)
        end
      else
      #Es una instancia
        _listSym = origen.private_methods(false).concat(origen.methods(false))
        _listaSym.each do |sym|
        _listaMetodos <<  origen.new.method(sym)
      end
    end
   end
    return _listaMetodos.select {|met| Condicion.new(met).validar(condiciones)}
  end

  def existe_modulo?(modulo)
##anda [30] pry(main)> Module.const_defined?(:Defensor)
    Module.const_defined?(modulo.to_s)

  end

  def existe_clase?(klass)
    ## Anda
    # Module.const_get(:Aspects).is_a?(Class)
    # => true

    begin

      Object.const_get(klass.to_s).is_a?(Class)
    rescue
      Object.const_get(klass.class.to_s).is_a?(Class)
    end

  end

  def find_aspects(*args)
    return 1
  end
############################################################

end
