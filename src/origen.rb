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
    @origen.metodos.select {|met| validar(met,condiciones)}

  end

  def metodos
    #si es objeto, todos sus metodos
    #si es modulo, todos los metodos de instancia
    #si es clase, todos los metodos de instancia
    listaobjetos = []
    if @origen.class.is_a?(Class) || @origen.class.is_a?(Module)
      listaobjetos = ObjectSpace.each_object(@origen).to_a
    else
      listaobjetos = [@origen]
    end
    listaobjetos.map {|obj| obj.private_methods(false).concat(@origen.methods(false)).map {|simbolo| obj.method(simbolo)}}
  end

  def existe_en_lista?(lista_origenes)
    lista_origenes.any? { |org| org.origen.class == self.class }
  end

end