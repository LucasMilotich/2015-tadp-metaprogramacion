require 'rspec'
require_relative '../src/origen'

describe 'test Origenes' do

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

  og_a = Origen.new(A)
  og_objA = Origen.new(A.new)


  it 'un origen de clase tiene 3 metodos' do
    expect(og_a.metodos.count).to eq 3
  end

  it 'origen de objeto tiene 3 metodos' do
  expect(og_objA.metodos.count).to eq 3
  end

  it 'origen de clase tiene 2 metodos publicos' do
    procpublic = og_a.is_public
    expect((og_a.where procpublic).count).to eq 2
  end

  it 'origen de clase tiene 1 metodo que empiece con b' do
    procname = og_a.name(/b.*/)
    expect((og_a.where procname).count).to eq 1
  end

  it 'origen de objeto tiene 2 metodos publicos' do
    procpublic = og_objA.is_public
    expect((og_objA.where procpublic).count).to eq 2
  end

  it 'origen tiene 2 metodos con 1 parametro obligatorio' do
    mand = og_a.mandatory
    procparam = og_a.has_parameters(1,mand)
    expect((og_a.where procparam).count).to eq 2
  end

  it 'origen tiene 1 metodo con 2 parametros' do
    procparam = og_a.has_parameters(2)
    expect((og_a.where procparam).count).to eq 1
  end

  it 'origen tiene 1 metodo con 5 parametros que empiezan con p ' do
    procparam = og_a.has_parameters(5,/p.*/)
    expect((og_a.where procparam).count).to eq 1
  end

  it 'origen no tiene metodos de 3 parametros' do
    procparam = og_a.has_parameters(3)
    expect((og_a.where procparam).count).to eq 0
  end

  it 'origen tiene 2 metodos que no cumplen 1 condicion' do
    procprivate = og_a.is_private
    procneg = og_a.neg(procprivate)
    expect((og_a.where procneg).count).to eq 2
  end

  it 'origen tiene 1 metodo que no cumple mas de una condicion' do
    procprivate = og_a.is_public
    procparam = og_a.has_parameters(2)
    procname = og_a.name(/j.*/)
    procneg = og_a.neg(procprivate,procparam,procname)
  end

  it 'origen tiene 1 metodo que cumple varias condiciones' do
    procpublic = og_a.is_public
    procparam = og_a.has_parameters(2)
    expect((og_a.where procpublic,procparam).count).to eq 1
  end

end