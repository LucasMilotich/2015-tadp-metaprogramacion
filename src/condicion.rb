module CondicionRegex
  def cumple_regex?(objeto, regex)
    #proc{|un_metodo|}
    regex.match(objeto).is_a?(MatchData)
  end
end

module CondicionParametros
  def cumplen_parametros?(block, cantidad)
    proc{|un_metodo| un_metodo.parameters.select(&block).size == cantidad}
  end
end

module Visibilidad
  def cumple_visibilidad(simbolo)
    proc {|un_metodo| un_metodo.owner.method(simbolo).call(false).include?(un_metodo.name)}
  end

  def is_private
    cumple_visibilidad(:private_instance_methods)
  end

  def is_public
    cumple_visibilidad(:public_instance_methods)
  end

end

module CantidadParametros
  include CondicionParametros

  def mandatory
    proc {|parametro| parametro.first == :req}
  end
  def optional
    proc {|parametro| parametro.first == :opt}
  end

  def has_parameters(cantidad, tipo = proc { |p| p })
    cumplen_parametros?(tipo,cantidad)
  end

end

module Selector
  include CondicionRegex

  def name(regex)
    proc{|un_metodo| cumple_regex?(un_metodo.name,regex)}
  end
end

module NombreParametros
  include CondicionRegex
  include CondicionParametros
  def has_parameters(cantidad, regex)
    cumplen_parametros?(proc{|p| cumple_regex?(p.last,regex)},cantidad)
  end
end

module NegCondicion

  def neg (condiciones)
    proc {|un_met| condiciones.all? {|cond| not(cond.call(un_met))}}
  end

end

module Condiciones
  include Visibilidad
  include NombreParametros
  alias_method :has_parameters_n, :has_parameters
  include CantidadParametros
  include Selector
  include NegCondicion

  def has_parameters(cantidad, arg = proc{|p| p})

    if arg.is_a?(Regexp) then
      _pro = has_parameters_n(cantidad, arg)
    else
      _pro = super(cantidad,arg)
    end
    _pro
  end

  def validar(metodo_a_analizar,condiciones)
    condiciones.all? {|cond| cond.call(metodo_a_analizar)}
  end

end
