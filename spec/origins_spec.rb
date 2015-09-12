require 'rspec'
require_relative '../src/aspects_nico'

describe 'Origins' do
  let (:prueba){
    Prueba.new
  }
  let (:test){
    Test.new
  }
  let (:origin){
    Origin.new
  }

  it 'Obtener origen de 1 Clase' do
    result=origin.find_origins(Prueba)
    expect(result.length).to eq(1)
  end

  it 'Obtener origen de 1 instancia de Clase' do
    result=origin.find_origins(Prueba.new)
    expect(result.length).to eq(1)
  end

  it 'Obtener origen de 2 Clases' do
    result=origin.find_origins([Prueba,Test])
    expect(result.length).to eq(2)
  end

  it 'Obtener origen de Clases, instancias y modulos' do
    result=origin.find_origins([Prueba,Test,Prueba.new, ModuleTest])
    expect(result.length).to eq(4)
  end

  it 'Obtener origen con regex identico' do
    result=origin.find_origins(/Prueba/)
    expect(result).to eq([Prueba])
  end

  it 'Obtener origen con regex' do
    result=origin.find_origins(/ModuleTe*/)
    expect(result).to eq([ModuleTest])
  end

  it 'Obtener origen de con  2 regex' do
    result=origin.find_origins(/Pru*/, /st$/)
    expect(result).to eq([Proc, Process, Prueba, FileTest, Digest, Test, ModuleTest])
  end

  it 'Obtener origen de con  2 regex' do
    result=origin.find_origins(/Pru*/, /st$/)
    expect(result).to eq([Proc, Process, Prueba, FileTest, Digest, Test, ModuleTest])
  end

  it 'Obtener metodo de clase' do
    result=origin.find_methods (Test)
    expect(result.any? {|x| x.to_s =="metodoDePrueba1_class"}).to eq(true)
  end

  it 'Obtener metodos de instancia' do
    result=origin.find_methods (Prueba.new)
    expect(result.any? {|x| x.to_s =="perro"}).to eq(true)
  end

  it 'Obtener metodos de instancia y clase' do
    result=origin.find_methods(Test, Prueba.new)
    expect(result.any? {|x| x.to_s =="perro"}).to eq(true)
    expect(result.any? {|x| x.to_s =="metodoDePrueba1_class"}).to eq(true)
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

class Test
  def metodoDePrueba1_inst
  end
  def metodoDePrueba2_inst
  end
  def metodoDePrueba3_inst
  end
  def self.metodoDePrueba1_class
  end
end

module ModuleTest
  def module_method
  end
end