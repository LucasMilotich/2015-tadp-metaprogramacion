class Aspects

  def self.on(*origenes)

    aspects_encontrados = find_aspects(*origenes)


    raise ArgumentError, " wrong number of arguments (0 for +1)" if origenes.size==0
    raise ArgumentError, "Origen Vacio" if aspects_encontrados==0


  end

  def self.find_aspects(*args)
  return 1
  end

end

