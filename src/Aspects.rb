class Aspects

  def self.on(arg, *args)
    aspects_encontrados=0
   # aspects_encontrados = find_aspects(arg, *args)


    raise ArgumentError, " wrong number of arguments (0 for +1)" if aspects_encontrados==0
    raise ArgumentError, "Origen Vacio" if aspects_encontrados==0

  end

  def self.find_aspects(*args)
  return 0
  end

end

