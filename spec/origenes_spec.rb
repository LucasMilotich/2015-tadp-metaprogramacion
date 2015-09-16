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



  it 'un origen de clase A tiene 3 metodos' do
    og = Origen.new(A)
    expect(og.metodos.count).to eq(3)
  end

  it 'origen de objeto tiene 3 metodos' do
  og = Origen.new(A.new)
  expect(og.metodos.count).to eq(3)
  end

  it 'origen de clase A devuelve 2 metodos publicos' do
    og = Origen.new(A)
    procpublic = og.is_public
    expect((og.where procpublic).count).to eq 2
  end

  it 'origen de clase A devuelve 1 metodo que empiece con b' do
    og = Origen.new(A)
    procname = og.name(/b.*/)
    expect((og.where procname).count).to eq 1
  end

  it 'origen de objeto A devuelve dos metodos publicos' do
    og = Origen.new(A.new)
    procpublic = og.is_public
    expect((og.where procpublic).count).to eq 2
  end

  


end