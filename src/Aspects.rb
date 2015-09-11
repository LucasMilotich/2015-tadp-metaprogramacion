#include_relative 'condicion.rb'

class Aspects


  attr_accessor :origenes

  def initialize
    @origenes = []
  end

  def self.on(*origenes_argumento,&bloque)

    raise ArgumentError, "Origen vacio" if origenes_argumento.size < 1
    raise ArgumentError, "Sin bloque" if !block_given?

    aspect = Aspects.new

    origenes_argumento.each do |origen|

      if aspect.es_ER?(origen)

        aspect.buscar_y_agregar(origen)

      else

        if aspect.existe_clase?(origen)

          aspect.origenes << origen

        else if aspect.existe_modulo?(origen)

               aspect.origenes << origen
             end
        end
      end

    end

    class_exec(&bloque)

    return aspect
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

  def es_ER?(argumento)
    argumento.is_a?(Regexp)
  end

  def buscar_y_agregar(regex)
     _lista = Object.constants.grep(regex).map {|regex_symbol| Object.const_get(regex_symbol)}
     _lista.each do |object|
      self.origenes << object
     end

  end

  def find_aspects(*args)
    return 1
  end

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

end


#Aspects.on (["aasd"]) do find_aspects(nil) end