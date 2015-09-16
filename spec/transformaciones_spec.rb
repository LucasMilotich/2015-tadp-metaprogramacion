require 'rspec'
require_relative '../src/origen'
require_relative '../src/transformacion'

describe 'Transformaciones' do

  class CL1
    def hace_algo(p1, p2)
      p1 + ' - ' +p2
    end

    def otro(p2, ppp)
      p2 + ': ' +ppp
    end
  end

  class CL2
    def saludar(x)
      "Hola " + x
    end
  end

  class CL3
    def saludar (x)
      "Chau " + x
    end
  end

  class CL4
    attr_accessor :x
    def m1(x,y)
      x + y
    end
    def m2(x)
      @x = x
    end
    def m3(x)
      @x = x
    end
  end

  it 'instead' do
    og = Origen.new(CL4)
    procname = og.name (/m3/)
    og.transform(og.where procname) do
      instead_of do |instance, *args|
        @x = 123
      end
    end
    instancia = CL4.new
    instancia.m3(10)
    expect(instancia.x).to eq 123
  end
end