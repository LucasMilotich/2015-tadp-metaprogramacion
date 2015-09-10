class Condicion

  attr_accessor :metodo

  def self.new(m)
    a = super()
    a.metodo = m
    a
  end

end

module CondicionRegex
  def cumple_regex?(objeto, regex)
    regex.match(objeto).class == MatchData
  end
end

module CondicionParametros
  def cumplen_condicion?(block, cantidad)
    self.metodo.parameters.select(&block).size == cantidad
  end
end

class CantidadParametros < Condicion
  include CondicionParametros

  mandatory = proc {|parametro| parametro.first == :req}
  optional = proc {|parametro| parametro.first == :opt}

  def has_parameters(cantidad, tipo = proc { |p| p })
    cumplen_condicion?(tipo,cantidad)

  end

end

class Visibilidad < Condicion

  def cumple_visibilidad?(visibilidad)
    @metodo.owner.method(visibilidad).call(false).include?(@metodo.name)
  end

  def is_private
    return cumple_visibilidad?(:private_instance_methods)
  end

  def is_public
    return cumple_visibilidad?(:public_instance_methods)
  end

end

class Selector < Condicion
  include CondicionRegex
  def name(regex)
    cumple_regex?(@metodo.name,regex)
  end
end

class NombreParametros < Condicion
    include CondicionRegex
    include CondicionParametros
    def has_parameters(cantidad, regex)
        cumplen_condicion?( proc {|parametro| cumple_regex?(parametro.last,regex)},cantidad)
    end
end

class NegCondicion < Condicion
  def neg (condicion, *condiciones)
    condicion.concat(condiciones).all? {|ci| self.ci == false}

  end
end