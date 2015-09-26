require 'rspec'
require_relative '../src/Aspects'

describe 'Aspects_test' do

  it 'completo con inyeccion de parametro' do
    class MiClase
      def hace_algo(p1, p2)
        p1 + '-' + p2
      end
      def hace_otra_cosa(p2, ppp)
        p2 + ':' + ppp
      end
    end

    Aspects.on MiClase do
      transform(where has_parameters(1, /p2/)) do
        inject(p2: 'bar')
      end
    end

    instancia = MiClase.new
    expect(instancia.hace_algo("foo","foo")).to eq("foo-bar")
    expect(instancia.hace_algo("foo")).to eq("foo-bar")
    expect(instancia.hace_otra_cosa("foo", "foo")).to eq("bar:foo")
  end

  it 'completo con inyeccion de proc' do
    class MiClase1
      def hace_algo(p1, p2)
        p1 + "-" + p2
      end
    end

    Aspects.on MiClase1 do
      transform(where has_parameters(1, /p2/)) do
        inject(p2: proc{ |receptor, mensaje, arg_anterior|
                 "bar(#{mensaje}->#{arg_anterior})" })
      end
    end

    expect(MiClase1.new.hace_algo('foo', 'foo')).to eq('foo-bar(hace_algo->foo)')
  end

  it 'completo con redireccion' do
    class A
      def saludar(x)
        "Hola, " + x
      end
    end

    class B
      def saludar(x)
        "Adiosin, " + x
      end
    end

    Aspects.on A do
      transform(where name(/saludar/)) do
        redirect_to(B.new)
      end
    end

    expect(A.new.saludar("Mundo")).to eq("Adiosin, Mundo")
  end

  it 'completo con before' do
    class MiClase
      attr_accessor :x
      def m1(x, y)
        x + y
      end
      def m2(x)
        @x = x
      end
      def m3(x)
        @x = x
      end
    end
    Aspects.on MiClase do
      transform(where name(/m1/)) do
        before do |instance, cont, *args|
          @x = 10
          new_args = args.map{ |arg| arg * 10 }
          cont.call(self, nil, *new_args)
        end
      end
    end
    instancia = MiClase.new
    expect(instancia.m1(1,2)).to eq(30)
    expect(instancia.x).to eq(10)
    end

  it 'completo con after' do
    class MiClase
      attr_accessor :x
      def m1(x, y)
        x + y
      end
      def m2(x)
        @x = x
      end
      def m3(x)
        @x = x
      end
    end
    Aspects.on MiClase do
      transform(where name(/m2/)) do
        after do |instance, *args|
          if @x > 100
            2 * @x
          else
            @x
          end
        end
      end
    end
    instancia = MiClase.new
    expect(instancia.m2(10)).to eq(10)
    expect(instancia.m2(200)).to eq(400)
  end

  it 'completo con instead of' do
    class MiClase
      attr_accessor :x
      def m1(x, y)
        x + y
      end
      def m2(x)
        @x = x
      end
      def m3(x)
        @x = x
      end
    end
    Aspects.on MiClase do
    transform(where name(/m3/)) do
      instead_of do |instance, *args|
        @x = 123
        end
      end
    end
    instancia = MiClase.new
    expect(instancia.m3(10)).to eq(123)
    expect(instancia.x).to eq(123)
  end

  it 'completo con varias transformaciones' do
    class A
      def saludar(x)
        "Hola, " + x
      end
    end

    class B
      def saludar(x)
        "Adiosin, " + x
      end
    end

    Aspects.on B do
      transform(where name(/saludar/)) do
        inject(x: "Tarola")
        redirect_to(A.new)
      end
    end
    expect(B.new.saludar("Mundo")).to eq("Hola, Mundo")
  end
end


