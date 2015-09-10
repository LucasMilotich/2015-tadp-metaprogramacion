require 'rspec'
require_relative '../src/condicion'

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

  #Selector
  it 'metodo publico matchea regex' do
    foo = Selector.new(metodos_publ.first)
    expect(foo.name(/foo/)).to be_truthy
  end

  it 'metodo privado matchea regex' do
    foo = Selector.new(metodos_priv.first)
    expect(foo.name(/fo{2}/)).to be_truthy
  end

  it 'metodo publico no matchea regex' do
    bar = Selector.new(metodos_publ.last)
    expect(bar.name(/fo{2}/)).to be_falsey
  end

  #Visibilidad
  it 'metodo publico es publico' do
    foo = Visibilidad.new(metodos_publ.first)
    expect(foo.is_public).to be_truthy
  end

  it 'metodo privado es privado' do
    foo = Visibilidad.new(metodos_priv.first)
    expect(foo.is_private).to be_truthy
  end

  it 'metodo privado no es publico' do
    prfoo = Visibilidad.new(metodos_priv.first)
    expect(prfoo.is_public).to be_falsey
  end

  #Cantidad parametros
  mandatory = proc {|parametro| parametro.first == :req}
  optional = proc {|parametro| parametro.first == :opt}

  it 'metodo de 5 parametros matchea' do
    foo = CantidadParametros.new(metodos_publ.first)
    expect(foo.has_parameters(5)).to be_truthy
  end

  it 'metodo de 5 parametros no matchea con 2' do
    foo = CantidadParametros.new(metodos_publ.first)
    expect(foo.has_parameters(2)).to be_falsey
  end

  it 'metodo de 2 parametros obligatorios matchea' do
    foo = CantidadParametros.new(metodos_publ.first)
    expect(foo.has_parameters(2,mandatory)).to be_truthy
  end

  it 'metodo de 3 parametros opcionales matchea' do
    foo = CantidadParametros.new(metodos_publ.first)
    expect(foo.has_parameters(3,optional)).to be_truthy
  end

  it 'metodo privado de 1 parametro obligatorio matchea' do
    foo = CantidadParametros.new(metodos_priv.first)
    expect(foo.has_parameters(1,mandatory)).to be_truthy
  end

  it 'metodo con menos parametros opcionales no matchea' do
    foo = CantidadParametros.new(metodos_publ.last)
    expect(foo.has_parameters(2,optional)).to be_falsey
  end

  #Nombre parametros
  it 'metodo de 2 parametros matchea regex' do
    foo = NombreParametros.new(metodos_publ.last)
    expect(foo.has_parameters(2,/p.*/)).to be_truthy
  end

  it 'metodo no matchea por parametros de mas en regex' do
    foo = NombreParametros.new(metodos_publ.first)
    expect(foo.has_parameters(2,/p.*/)).to be_falsey
  end

  it 'metodo no matchea parametros con regex' do
    foo = NombreParametros.new(metodos_publ.last)
    expect(foo.has_parameters(1,/f.*/)).to be_falsey
  end

  #Neg

  it 'metodo niega 1 condicion y matchea' do
    foo = NegCondicion.new(metodos_publ.last)
    expect(foo.neg(is_private)).to be_truthy
  end

  it 'metodo niega todas las condiciones (>1) y matchea' do
    foo = NegCondicion.new(metodos_publ.last)
    expect(foo.neg(is_private,has_parameters(1),name(/j.*/))).to be_truthy
  end

  it 'metodo no niega una condicion y no matchea' do
    foo = NegCondicion.new(metodos_publ.last)
    expect(foo.neg(is_private,has_parameters(2))).to be_falsey
  end

end