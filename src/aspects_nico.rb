$LOAD_PATH << '.'   #Usamos esto o require_relative
require "origins"

class AspectsNico
  include Origins
  def self.on(*origins,&bloque)
  find_origins(*origins)
  end

  def self.resolve_regex(regex)
    Object.constants.grep(regex).map {|regex_symbol| Object.const_get(regex_symbol)}
  end

  def self.find_origins(*possible_origins)
    origins = []

    possible_origins.each do |an_origin|
      an_origin.is_a?(Regexp) ? origins+= resolve_regex(an_origin) : origins+= [an_origin]
    end

    origins
  end


end

class Prueba
  include Origins
  attr_accessor :perro
  attr_reader :perro_lectura
  attr_writer :perro_escritura
  def test
    resolve_regex("a")
  end
end