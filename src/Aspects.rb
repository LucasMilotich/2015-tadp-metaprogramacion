
class Aspects

  def self.on(*origenes,&bloque)

    raise ArgumentError, "Origen vacio" if origenes.size < 1
    raise ArgumentError, "Sin bloque" if !block_given?

    #a = Aspects.new
    #a.instance_eval(&bloque)

    class_exec(&bloque)


    #a.class_eval


  end

  def self.find_aspects(*args)

  return "pepeeeee"
  end

end

#Aspects.on (["aasd"]) do find_aspects(nil) end