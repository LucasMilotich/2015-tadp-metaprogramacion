require 'test/spec'
require '../src/condicion'

describe 'test condiciones' do


  it '' do
    class MiClase
      def foo(p1, p2, p3, p4='a', p5='b', p6='c')
        'Foo'
      end
      def bar(p1, p2='a', p3='b', p4='c')
        'Bar'
      end
    end

    metodos =  MiClase.new.public_methods(false).map {|m| MiClase.new.method(m)}



  end
end