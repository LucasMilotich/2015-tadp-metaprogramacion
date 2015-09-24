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
    expect(instancia.hace_otra_cosa("foo","foo")).to eq("bar:foo")
  end
end