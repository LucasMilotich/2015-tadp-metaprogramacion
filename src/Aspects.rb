require_relative 'origen.rb'

class Aspects

  def self.on(origen_arg,*origenes_argumento,&bloque)
    _argumentos = [origen_arg].concat(origenes_argumento)
    origenes_posta = []

    raise ArgumentError, "Sin bloque" if !block_given?

    _argumentos.each do |argumento|
      if es_ER?(argumento)
        buscar_y_agregar(argumento, origenes_posta)
      else
        if argumento.instance_of?(Module) || argumento.instance_of?(Object) || argumento.instance_of?(Class)
          origenes_posta << Origen.new(argumento)
        end
      end
    end

    raise ArgumentError, "Origen vacio" if origenes_posta.empty?

    origenes_posta.each do |origen|
      origen.instance_eval &bloque
    end
  end

  def self.es_ER?(argumento)
    argumento.is_a?(Regexp)
  end

  def self.buscar_y_agregar(regex, lista_origenes)
     _lista = Object.constants.grep(regex).map {|regex_symbol| Object.const_get(regex_symbol)}
     if !_lista.empty?
       _lista.each do |object|
         lista_origenes << Origen.new(object)
       end
     end
  end

end