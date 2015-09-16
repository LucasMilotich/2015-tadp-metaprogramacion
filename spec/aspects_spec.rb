require 'rspec'
require_relative '../src/Aspects'

describe 'Aspects_test' do

  it 'Aspects sin origen debe dar error' do
    expect(Aspects.on do 'chori' end).to raise_error(ArgumentError)
  end

end



