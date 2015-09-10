require 'rspec'
require_relative '../src/Aspects'

  describe('Aspect tests') do

    it 'Aspects sin origenes tira excepcion' do
      expect(Aspects.on).to raise_error(ArgumentError)
    end
end




