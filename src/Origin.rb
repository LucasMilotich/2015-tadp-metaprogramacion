require_relative 'Condition'
class Origin < Condition

  attr_accessor :_origins, :_methods
  def initialize
  end


  def hacer_magia(*origins_to_validate, &bloque)
    @_origins=self.find_origins(origins_to_validate)
    @_methods =self.find_methods(@_origins)
    self.instance_eval(&bloque)
  end

  def where(*conditions,&block)
    # condicion = Condition.new
    # condicion.metodos = self.find_methods(@_origins)
    bla= @_methods.select {
        |metodo| conditions.all? {|condition| condition.call(metodo)}
    }
    aspector = Aspector.new
    bla
#    aspector.instance_exec(&block)
  end

  def transform (*methods_to_transform,&block)
    methods_filtered=self.where(*methods_to_transform) # Hago q explote para ver la salida en el test
    transformer = Transformer.new
    transformer.instance_exec(&block)
    #TODO no anda con varios transformers
  end

  def find_methods(*origins)
    all_methods= []
    origins.flatten.each { |an_origin| an_origin.is_a?(Class) ? all_methods<< an_origin.methods(true) : all_methods<< an_origin.class.instance_methods(true)}
    all_methods.flatten.uniq
  end

  def resolve_regex(regex)
    Object.constants.grep(regex).map {|regex_symbol| Object.const_get(regex_symbol)}
  end

  def find_origins(*possible_origins)
    origins = []
    possible_origins.each do |an_origin|
      an_origin.is_a?(Regexp) ? origins+= resolve_regex(an_origin) : origins+= [an_origin]
    end
    origins.empty? ? (raise 'Origen vacio') : origins.flatten.uniq #TODO no debe permitir repetidos?
  end

end