class Origin

  def resolve_regex(regex)
    Object.constants.grep(regex).map {|regex_symbol| Object.const_get(regex_symbol)}
  end

  def find_origins(*possible_origins)
    origins = []

    #TODO debo incluir las superclases de las clases que entren
    possible_origins.each do |an_origin|
      an_origin.is_a?(Regexp) ? origins+= resolve_regex(an_origin) : origins+= [an_origin]
    end

    origins.empty? ? (raise 'Origen vacio') : origins.uniq #TODO no debe permitir repetidos?
  end

end