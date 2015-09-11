require 'rspec'
require_relative '../src/Aspects'

describe 'Aspects_test' do
  let (:una_clase){
    Object.new
  }

  it 'Guardar tantos elemtos como origenes puse' do

    a = Aspects.on una_clase,Object,Module do "test" end
    expect(a.origenes.size).to eq(3)
  end

  it 'Validar poner clases' do
    a = Aspects.on Object do "test" end
    expect(a.origenes.include?(Object) == true)
  end

  it 'existe_modulo?' do
    expect (Aspects.new.existe_modulo?(Module) == true)
  end

  it 'existe_clase?' do
    expect(Aspects.new.existe_clase?(Object)==true)
  end

  it 'es_er?' do
   expect(Aspects.new.es_ER?(/.*Pr/)==true)
  end

  it 'buscar_y_agregar' do
    a = Aspects.new
    a.buscar_y_agregar(/.*Pr/)
    expect(a.origenes.size == 4)
  end

end



