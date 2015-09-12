require 'rspec'
require_relative '../src/Condition'

describe 'test condiciones' do

  class A
    def foo(p1, p2, p4='a', p5='b', p6='c')
      'Foo'
    end

    def bar(p1, p2='a')
      'Bar'
    end

    private
    def prfoo(p1)
      'Private Foo'
    end
  end

  metodos_publ = A.public_instance_methods(false).map {|m| A.new.method(m)}
  metodos_priv = A.private_instance_methods(false).map {|m| A.new.method(m)}

  foo = Condicion.new(metodos_publ.first)
  bar = Condicion.new(metodos_publ.last)
  prfoo = Condicion.new(metodos_priv.first)

  #Selector
  it 'metodo publico matchea regex' do
    expect(foo.name(/foo/)).to be_truthy
  end

  it 'metodo privado matchea regex' do
    expect(prfoo.name(/fo{2}/)).to be_truthy
  end

  it 'metodo publico no matchea regex' do
    expect(bar.name(/fo{2}/)).to be_falsey
  end

  #Visibilidad
  it 'metodo publico es publico' do
    expect(foo.is_public).to be_truthy
  end

  it 'metodo privado es privado' do
    expect(prfoo.is_private).to be_truthy
  end

  it 'metodo privado no es publico' do
    expect(prfoo.is_public).to be_falsey
  end

  #Cantidad parametros
  mandatory = proc {|parametro| parametro.first == :req}
  optional = proc {|parametro| parametro.first == :opt}

  it 'metodo de 5 parametros matchea' do
    expect(foo.has_parameters(5)).to be_truthy
  end

  it 'metodo de 5 parametros no matchea con 2' do
    expect(foo.has_parameters(2)).to be_falsey
  end

  it 'metodo de 2 parametros obligatorios matchea' do
    expect(foo.has_parameters(2,mandatory)).to be_truthy
  end

  it 'metodo de 3 parametros opcionales matchea' do
    expect(foo.has_parameters(3,optional)).to be_truthy
  end

  it 'metodo privado de 1 parametro obligatorio matchea' do
    expect(bar.has_parameters(1,mandatory)).to be_truthy
  end

  it 'metodo con menos parametros opcionales no matchea' do
    expect(bar.has_parameters(2,optional)).to be_falsey
  end

  #Nombre parametros
  it 'metodo de 2 parametros matchea regex' do
    expect(bar.has_parameters(2,/p.*/)).to be_truthy
  end

  it 'metodo no matchea por parametros de mas en regex' do
    expect(foo.has_parameters(2,/p.*/)).to be_falsey
  end

  it 'metodo no matchea parametros con regex' do
    expect(bar.has_parameters(1,/f.*/)).to be_falsey
  end

  #Neg
  #Se extiende a la clase Condicion para que las funciones llamadas dentro de neg est�n dentro de su contexto.
  module Funciones_para_negar
    def negar_private
        self.neg(is_private)
    end
    def negar_varios
       self.neg(is_private,has_parameters(1),name(/j.*/))
    end
    def negar_falso
      self.neg(is_private,has_parameters(2))
    end
  end

  it 'metodo niega 1 condicion y matchea' do
    bar.extend Funciones_para_negar
    expect(bar.negar_private).to be_truthy
  end

  it 'metodo niega todas las condiciones (>1) y matchea' do
    bar.extend Funciones_para_negar
    expect(bar.negar_varios).to be_truthy
  end

  it 'metodo no niega una condicion y no matchea' do
    bar.extend Funciones_para_negar
    expect(bar.negar_falso).to be_falsey
  end

  #varios
  it 'metodo evalua varias condiciones que cumple' do
    expect(foo.validar(is_public,has_parameters(6))).to be_truthy
  end
end