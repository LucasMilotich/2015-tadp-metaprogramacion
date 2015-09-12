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
    lista_metodos = nil
    (@origen.instance_of?(Class) || @origen.instance_of?(Module)) ?
        lista_metodos = @origen :  lista_metodos = @origen.singleton_class
    lista_metodos.private_instance_methods(false).concat(lista_metodos.public_instance_methods(false)).map {|simbolo| lista_metodos.method(simbolo)}
  end

  def existe_en_lista?(lista_origenes)
    lista_origenes.any? { |org| org.origen.class == self.class }
  end
end