require_relative 'condicion.rb'
require_relative 'Aspects.rb'

class Origen
  include Condicion
  attr_accessor :origen

  def self.new(un_argumento)
    o = super()
    o.origen = un_argumento
    return o
  end

  def where (*condiciones)
    @origen.metodos.select {|met| validar(met,condiciones)}
  end

  def metodos
    #si es objeto, todos sus metodos
    #si es modulo, todos los metodos de instancia
    #si es clase, todos los metodos de instancia

    lista = []
    if @origen.is_a?(Class) || @origen.is_a?(Module)
      lista = @origen.private_instance_methods(false).concat(@origen.instance_methods(false))

      return lista.map {|s| @origen.new.method(s)}
    else
      lista = @origen.private_methods(false).concat(@origen.methods(false))
      return lista.map{|s| @origen.method(s)}
    end
  end

  def existe_en_lista?(lista_origenes)
    lista_origenes.any? { |org| org.origen.class == self.class }
  end

end