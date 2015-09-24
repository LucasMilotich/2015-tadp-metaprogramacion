require 'rspec'
require_relative '../src/transformacion'

describe 'Transformaciones' do

  class CL1
    def hace_algo(p1, p2)
      p1 + '-' +p2
    end

    def otro(p2, ppp)
      p2 + ':' +ppp
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

  #En todos los tests se eval�a con dos objetos generados por la misma clase.
  #En unos se verifican que el cambio se aplique en ambos, y en otros en uno solo.

  it 'redirect_to en objeto' do
    un_objeto = CL2.new
    otro_objeto = CL2.new
    saludar_obj1 = un_objeto.method(:saludar)
    Transformacion.new(saludar_obj1).redirect_to(CL3.new)
    expect(un_objeto.saludar("Gil")).to eq("Chau Gil")
    expect(otro_objeto.saludar("Gil")).to eq("Hola Gil")
  end

  it 'redirect_to en clase' do
    saludar_cl2 = CL2.instance_method(:saludar)
    Transformacion.new(saludar_cl2).redirect_to(CL3.new)
    un_objeto = CL2.new
    otro_objeto = CL2.new
    expect(un_objeto.saludar("Gil")).to eq("Chau Gil")
    expect(otro_objeto.saludar("Gil")).to eq("Chau Gil")
  end

  it 'instead of en objeto' do
    un_objeto = CL4.new
    otro_objeto = CL4.new
    m3_cl4 = un_objeto.method(:m3)
    Transformacion.new(m3_cl4).instead_of do
      |instance, *args| @x = 123
    end
    expect(un_objeto.m3(10)).to eq(123)
    expect(otro_objeto.m3(10)).to eq(10)
  end

  it 'instead of con clase' do
    m3_cl4 = CL4.instance_method(:m3)
    Transformacion.new(m3_cl4).instead_of do
    |instance, *args| @x = 123
    end
    un_objeto = CL4.new
    otro_objeto = CL4.new
    expect(un_objeto.m3(10)).to eq(123)
    expect(otro_objeto.m3(10)).to eq(123)
  end

  it 'before en clase' do
    m1_cl4 = CL4.instance_method :m1
    Transformacion.new(m1_cl4).before do |instance, contexto, *args|
      @x = 10
      new_args = args.map{ |arg| arg * 10 }
      #contexto.call(self,nil, *new_args)
      contexto.call(*new_args)
    end
    un_obj = CL4.new
    otro_obj = CL4.new
    expect(un_obj.m1(1,2)).to eq(30)
    expect(otro_obj.m1(1,2)).to eq(30)
  end

  it 'after en clase' do
    un_obj = CL4.new

    m2_cl4 = CL4.instance_method(:m2)
    Transformacion.new(m2_cl4).after do |instance, *args|
      if @x > 100
        2 * @x
      else
        @x
      end
    end

    expect(un_obj.m2(10)).to eq(10)
    expect(un_obj.m2(200)).to eq(400)

    otro_obj = CL4.new
    expect(otro_obj.m2(10)).to eq(10)
    expect(otro_obj.m2(200)).to eq(400)
  end

  it 'inject valor normal en clase' do
    un_obj = CL1.new
    algo_meth = CL1.instance_method(:hace_algo)
    Transformacion.new(algo_meth).inject(p2: "bar")
    expect(un_obj.hace_algo("foo")).to eq("foo-bar")
    expect(un_obj.hace_algo("foo","foo")).to eq("foo-bar")

    otro_obj = CL1.new
    expect(otro_obj.hace_algo("foo")).to eq("foo-bar")
    expect(otro_obj.hace_algo("foo","foo")).to eq("foo-bar")
  end
  it 'inject valor normal en clase - pepe' do
    un_obj = CL1.new
    algo_meth = CL1.instance_method(:hace_algo)
    Transformacion.new(algo_meth).inject(p2: "pepe")
    expect(un_obj.hace_algo("foo")).to eq("foo-pepe")
    expect(un_obj.hace_algo("foo","foo")).to eq("foo-pepe")

    otro_obj = CL1.new
    expect(otro_obj.hace_algo("foo")).to eq("foo-pepe")
    expect(otro_obj.hace_algo("foo","foo")).to eq("foo-pepe")
  end


  it 'inject valor normal en instancia' do
  un_obj = CL1.new
  algo_meth = un_obj.method(:hace_algo)
  Transformacion.new(algo_meth).inject(p2: "bar")
  expect(un_obj.hace_algo("foo")).to eq("foo-bar")
  expect(un_obj.hace_algo("foo","foo")).to eq("foo-bar")
  end

  it 'inject proc' do
    un_obj = CL1.new
    algo_meth = CL1.instance_method(:hace_algo)
    Transformacion.new(algo_meth).inject(p2: proc{|receptor, mensaje, arg_anterior| "bar(#{mensaje}->#{arg_anterior})"} )
    expect(un_obj.hace_algo("foo","foo")).to eq("foo-bar(hace_algo->foo)")
  end




end