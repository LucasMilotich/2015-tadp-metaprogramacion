require 'rspec'
require_relative '../src/aspects_nico'

describe 'Aspects_test' do
  let (:prueba){
    Prueba.new
  }
  let (:test){
    Test.new
  }
  let (:origin){
    Origin.new
  }


  it 'bleh' do
  AspectsNico.on Prueba.new do transform (where name(/perro/), name(/.le*/)) do inject (1) end end
    expect(array.length).to eq(0)
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