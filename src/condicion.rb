class Condicion
  attr_reader :metodo
end

class CantidadParametros < Condicion

  mandatory = lambda do |parametro| parametro.first == :req end
  optional = lambda do |parametro| parametro.first == :opt end

  def has_parameters(cantidad, *tipo)
    tipo=[] ? @metodo.parameters.size >= cantidad : @metodo.parameters.select tipo.size >= cantidad

    #puts tipo
  end

end

class Visibilidad

  def cumple_visibilidad?(visibilidad)
    @metodo.owner.visibilidad(false).include?(@metodo.name)
  end

  def is_private
    cumple_visibilidad?(:private_instance_methods)
    #@metodo.owner.private_instance_methods(false).include?(@metodo.name)
  end

  def is_public
    cumple_visibilidad?(:public_instance_methods)
    #@metodo.owner.public_instance_methods(false).include?(@metodo.name)
  end

end

