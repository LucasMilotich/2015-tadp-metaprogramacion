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

  it 'instead of con objeto' do
    obj_cl4 = CL4.new
    m3_cl4 = obj_cl4.method(:m3)
    Transformacion.new(m3_cl4).instead_of do
      |instance, *args| @x = 123
    end
    expect(obj_cl4.m3(10)).to eq(123)
  end

  it 'instead of con clase' do
    m3_cl4 = CL4.instance_method(:m3)
    Transformacion.new(m3_cl4).instead_of do
      |instance, *args| @x = 123
    end
    expect(CL4.new.m3(10)).to eq(123)
  end
end