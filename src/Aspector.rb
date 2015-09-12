require_relative 'Origin'
require_relative 'Transformer'
require_relative 'Condition'

class Aspector
  attr_accessor :origins, :_methods
  def initialize

  end

  def transform (*conditions,&block)
    #filtro los metodos por las condiciones
    #@_methods = self.find_methods(@origins)
    methods_filtered=self.where(*conditions)
    transformer = Transformer.new
    transformer.instance_exec(&block)
    #TODO no anda con varios transformers
  end

end