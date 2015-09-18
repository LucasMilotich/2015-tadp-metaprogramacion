require 'rspec'
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

  it 'redirect_to' do
    obj_cl2 = CL2.new()
    saludar_cl2 = obj_cl2.method(:saludar)
    t = Transformacion.new(saludar_cl2)
    t.redirect_to(CL3.new)
    expect(obj_cl2.saludar("Gil")).to eq("Chau Gil")
  end


end