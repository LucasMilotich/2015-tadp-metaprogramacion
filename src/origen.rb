require_relative 'condicion.rb'
require_relative 'Aspects.rb'

class Origen
  include Condiciones
  attr_accessor :origen

  def self.new(un_argumento)
    o = super()
    o.origen = un_argumento
    return o
  end

  def where (*condiciones)
    metodos.select {|met| validar(met,condiciones)}
  end

  def metodos
    if @origen.is_a?(Class) or @origen.is_a?(Module)
      return (@origen.public_instance_methods(false) + @origen.private_instance_methods(false)).map {|simbolo| @origen.instance_method(simbolo)}
    else
      return (@origen.public_methods(false) + @origen.private_methods(false)).map {|simbolo| @origen.method(simbolo)}
    end
  end

  def existe_en_lista?(lista_origenes)
    lista_origenes.any? { |org| org.origen.class == self.class }
  end

  def transform (*lista_metodos)

  end

end