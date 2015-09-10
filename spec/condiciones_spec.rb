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
  end

  it 'un metodo cumple selector' do
    metodos = A.public_instance_methods(false).map {|m| A.new.method(m)}
    foo = Selector.new(metodos.first)
    regex = /foo/

    expect(foo.name(regex)).to be_truthy
  end

end