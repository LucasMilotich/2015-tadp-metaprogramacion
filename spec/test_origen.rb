require 'rspec'
require_relative '../src/Origen'


  describe 'origen' do

    let (:un_origen){
      Origen.new
    }

    it 'test' do
      un_origen.decir

    end


  end




