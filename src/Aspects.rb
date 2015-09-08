class Aspects

  def self.on(*arg)
    aspects_encontrados = find_aspects(*args)

    throw(ArgumentError,"Origen Vacio") if aspects_encontrados.size==0

  end

  def find_aspects(*args)
  return 1
  end

end

