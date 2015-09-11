require_relative 'Origin'
require_relative 'Transformer'
class Aspector
  attr_accessor :origins, :methods
  def initialize

  end

  def hacer_magia(*origins_to_validate, &bloque)
    origin = Origin.new
    @origins=origin.find_origins(origins_to_validate)
    self.instance_exec(&bloque)
  end

  def find_methods(*origins)
    all_methods= []
    @origins.each { |an_origin| an_origin.is_a?(Class) ? all_methods<< an_origin.methods(false) : all_methods<< an_origin.class.instance_methods(false)}
    all_methods
  end

  def where (*conditions)
    "es el where"
  end

  def transform (*conditions,&block)
    #filtro los metodos por las condiciones
    @methods = self.find_methods(@origins)
    methods_filtered=self.where(*conditions)
    transformer = Transformer.new
    transformer.instance_exec(&block)
    #TODO no anda con varios transformers
  end


end