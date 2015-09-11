require_relative 'Aspector.rb'
class AspectsNico

  def initialize
  end

  def self.on(*origins_to_validate,&bloque)
    raise ArgumentError, "Origen vacio" if origins_to_validate.empty?
    raise ArgumentError, "Sin bloque" if !block_given?
    aspector = Aspector.new
    aspector.hacer_magia(*origins_to_validate, &bloque)
  end

end


class Prueba
  attr_accessor :perro
  attr_reader :perro_lectura
  attr_writer :perro_escritura
  def initialize
  end

  def test
    "probando"
  end

end