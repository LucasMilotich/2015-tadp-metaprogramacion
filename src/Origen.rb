class Aspecto

def self.on(*arg)

end

end

#METODO ON  - El bloque se deberia llamar implicitamente
  #ver metodo YIELD https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/18-blocks/lessons/54-yield
#EJECUCION DE METODOS -
  #Se podria usar un patron command para poder ejecutar sucesivamente todos los metodos del bloque
#TRANSFORMACIONES - Se podria usar un Strategy
#BLOQUE  - si se le pasa el contexto al bloque, los metodos tipo where, transform,etc podrian ser llamados desde Aspecto
#WHERE - Ver si las condiciones que recibe tienen que estar definidas dentro de la clase
