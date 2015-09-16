class Condition

  def name(regex)
   proc {|metodo| regex.match(metodo).is_a?(MatchData)}
  end

  def cumplen_condicion(block, cantidad)
    self.metodo.parameters.select(&block).size == cantidad
  end

  def cumplen_condicion?(visibilidad)
    @metodo.owner.method(visibilidad).call(false).include?(@metodo.name)
  end

  def is_private
    return cumple_visibilidad?(:private_instance_methods)
  end

  def is_public
    return cumple_visibilidad?(:public_instance_methods)
  end

end
