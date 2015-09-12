module CondicionRegex
  def cumple_regex?(objeto, regex)
    regex.match(objeto).is_a?(MatchData)
  end
end

module CondicionParametros
  def cumplen_parametros?(block, cantidad)
    parameters.select(&block).size == cantidad
  end
end

module Visibilidad
  def cumple_visibilidad?(visibilidad, quien)
    owner.method(visibilidad).call(false).include?(quien)
  end

  def is_private
    proc {|un_metodo| un_metodo.cumple_visibilidad?(:private_instance_methods, un_metodo)}
  end

  def is_public
    proc {|un_metodo| un_metodo.cumple_visibilidad?(:public_instance_methods, un_metodo)}
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
    proc{|un_metodo| un_metodo.cumplen_parametros?(tipo,cantidad)}
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
    proc {|un_metodo| un_metodo.cumplen_parametros?
    ( proc{|parametro| cumple_regex?(parametro.last,regex)},cantidad)}
  end
end

module NegCondicion

  def neg (*condiciones)
    proc {|un_met| condiciones.all? {|cond| not(cond.call(un_met))}}
  end

end

module Condiciones
  attr_accessor :metodo

  include Visibilidad
  include NombreParametros
  alias_method :has_parameters_n, :has_parameters
  include CantidadParametros
  include Selector
  include NegCondicion

  def has_parameters(cantidad, arg = proc { |p| p } )

    if arg.is_a?(Regexp) then
      _pro = has_parameters_n(cantidad, arg)
    else
      _pro = super(cantidad,arg)
    end
    _pro
  end

  def validar(metodo_a_analizar,*condiciones)
    condiciones.all? {|cond| cond.call(metodo_a_analizar)}
  end

end
