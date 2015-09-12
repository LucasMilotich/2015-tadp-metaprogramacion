require_relative 'Aspector.rb'
class AspectsNico

  def initialize
  end

  def self.on(*origins_to_validate,&bloque)
    raise ArgumentError, "Origen vacio" if origins_to_validate.empty?
    raise ArgumentError, "Sin bloque" if !block_given?
    origin = Origin.new
    origin.hacer_magia(*origins_to_validate, &bloque)
  end

end


