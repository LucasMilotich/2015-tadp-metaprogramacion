
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

      if es_ER?(origen)

        buscar_y_agregar(origen,aspect)



      else
        if existe_clase?(origen)

          aspect.origenes << origen

        else if existe_modulo?(origen)

               aspect.origenes << origen

        end


      end
    end





    #a = Aspects.new
    #a.instance_eval(&bloque)




    #a.class_eval


end
    class_exec(&bloque)
  return aspect
  end

def self.existe_modulo?(modulo)
##anda [30] pry(main)> Module.const_defined?(:Defensor)
#  => true
  #Required::

    Module.const_defined?(:modulo)

end

def self.existe_clase?(klass)
  ## Anda
  # Module.const_get(:Aspects).is_a?(Class)
  # => true

    _local_klass = Module.const_get(:klass)
    return _local_klass.is_a?(Class)
  rescue NameError
    return false
  end

def self.es_ER?(argumento)
   if argumento.class.to_s[0]=='/'
      return true
    end
    else return false;
 end

def self.buscar_y_agregar(regex,instancia_aspecto)

    #buscar las clases/modulos

  lista_origenes = []
  instancia_aspecto.origenes << lista_origenes # buscar como agregar una lista a una lista (append)


end

def self.find_aspects(*args)

  return 1

end



end

#Aspects.on (["aasd"]) do find_aspects(nil) end