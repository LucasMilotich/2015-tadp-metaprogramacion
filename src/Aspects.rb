
class Aspects


  attr_accessor :origenes


def self.on(*origenes,&bloque)

    raise ArgumentError, "Origen vacio" if origenes.size < 1
    raise ArgumentError, "Sin bloque" if !block_given?

    origenes.each do |origen|
      if es_ER?(origen) then
        buscar(origen)
        #si devuelve algo != de nil, agregar a origenes
      else
        if existe_clase?(origen)
          origenes << origen

        else if existe_modulo?(origen)
               origenes << origen
        end


      end
    end





    #a = Aspects.new
    #a.instance_eval(&bloque)




    #a.class_eval


end
    class_exec(&bloque)
  end

def self.existe_modulo?(modulo)
##testear
  Required::Module.const_defined?(:modulo)

end

def self.existe_clase?(class_name)
    klass = Module.const_get(class_name)
    return klass.is_a?(Class)
  rescue NameError
    return false
  end

def self.es_ER?(argumento)
   if argumento[0]=='/'
      return true
    end
    else return false;
 end

def self.buscar(regex)

end

def self.find_aspects(*args)

  return 1

end



end

#Aspects.on (["aasd"]) do find_aspects(nil) end