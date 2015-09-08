
=begin
#METODO ON  - El bloque se deberia llamar implicitamente
  #ver metodo YIELD https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/18-blocks/lessons/54-yield
#EJECUCION DE METODOS -
  #Se podria usar un patron command para poder ejecutar sucesivamente todos los metodos del bloque
#TRANSFORMACIONES - Se podria usar un Strategy
#BLOQUE  - si se le pasa el contexto al  bloque, los metodos tipo where, transform,etc podrian ser llamados desde Aspecto
#WHERE - Ver si las condiciones que recibe tienen que estar definidas dentro de la clase
#METODOS - En la clase Aspects, se deberian usar metodos de clase. Ej.: self.on



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''                            Mini resumen                            ''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Origenes:     miClase, miModulo, miObjeto.

Condiciones:  +Selector:    Se cumple cuando el selector del metodo respeta una cierta regex (nombre del metodo)
              +Visibilidad: Se cumple si el metodo es privado o publico
              +CantParams:  Si tiene exactamente N parametros obligatorios, opcionales o ambos
              +NameParams:  Si tiene exactamente N parametros cuyo nombre cumple cierta regex
              +Negacion:    Esta condicion recibe otras condiciones por param. y se cumple cdo ninguna de ellas se cumple

Transformaciones:

*InyeccionDeParametro
*Redireccion: recibe un objeto q va a ser quien ejecute el metodo en vez del receptor original
*InyeccionDeLogica: Antes, Despues, EnlugarDe el codigo original del metodo
*

=end