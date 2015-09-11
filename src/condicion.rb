module CondicionRegex
  def cumple_regex?(objeto, regex)
    regex.match(objeto).is_a?(MatchData)
  end
end

module CondicionParametros
  def cumplen_condicion?(block, cantidad)
    self.metodo.parameters.select(&block).size == cantidad
  end
end

module Visibilidad
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

module CantidadParametros
  include CondicionParametros

  mandatory = proc {|parametro| parametro.first == :req}
  optional = proc {|parametro| parametro.first == :opt}

  def has_parameters(cantidad, tipo = proc { |p| p })
    cumplen_condicion?(tipo,cantidad)

  end

end

module Selector
  include CondicionRegex
  def name(regex)
    cumple_regex?(@metodo.name,regex)
  end
end

module NombreParametros
  include CondicionRegex
  include CondicionParametros
  def has_parameters(cantidad, regex)
    cumplen_condicion?( proc {|parametro| cumple_regex?(parametro.last,regex)},cantidad)
  end
end

module NegCondicion

  def neg (*condiciones)
    condiciones.all? {|ci| ci == false}
  end

end

class Condicion
  include Visibilidad
  include NombreParametros
  alias_method :has_parameters_n, :has_parameters
  include CantidadParametros
  include Selector
  include NegCondicion

  attr_accessor :metodo

  def self.new(m)
    a = super()
    a.metodo = m
    a
  end

  def has_parameters(cantidad, arg = proc { |p| p } )
    if arg.is_a?(Regexp) then
      has_parameters_n(cantidad, arg)
    else
      super(cantidad,arg)
    end
  end

  def validar(*condiciones)
    condiciones.all? {|ci| ci}
  end

end
