import tipos.*
import wollok.game.*

class Ataque {
  const property nombre
  const danioBase
  const property nombreImagen
  var property position = game.at(50, 5)
  method image() = "ataque" + self.nombreImagen()

  // Método que cada ataque debe implementar
  method ejecutar(pokemonAtacante, pokemonOponente) {
    game.say(pokemonAtacante, "Ejecuta Ataque " + self.nombre())
    pokemonAtacante.irAtacar() // Semaforo para que se acerque a su oponente
    
    game.schedule(100, {}) 
    const danioTotal = self.calcularEfecto(pokemonAtacante, pokemonOponente)
    pokemonOponente.recibirDanio(danioTotal)
    // Mostrar el valor actual de vida
    game.say(pokemonOponente, "Vida restante: " + pokemonOponente.vida().toString())
    
    /* Aca podriamos meter visuales */
    // game.say(pokemonOponente, "AUCH") 

    // Volver a la posicion inicial
    game.schedule(300, {pokemonAtacante.volverDeAtacar()})
  }

  method calcularEfecto(pokemonAtacante, pokemonOponente){
    const multiplicador = self.calcularMultiplicador(pokemonAtacante.tipo(), pokemonOponente.tipo())
    const danioTotal = danioBase * multiplicador
    return danioTotal
  }

  // Metodo para calcular la efectividad del ataque
  method calcularMultiplicador(tipoAtacante, tipoOponente) {
    if (tipoAtacante == tipoOponente) {
      return 0.5
    } else {
      if (tipoOponente.debilidad().contains(tipoAtacante)) {
        return 2
      } else {
        return 1
      }
    }
  }

  method cambiarPosicion(indice) {
    if (indice < 4) {
      const x = self.position().x()
      const y = self.position().y()
      position = game.at(x+indice*10, y)
    } else {
      position = game.at(40,8)
    }
    
  }
}

// Ataques genericos
object golpeSeco inherits Ataque (nombre = "Golpe Seco", danioBase = 10, nombreImagen = "GolpeSeco.png") {
  override  method calcularEfecto(pokemonAtacante, pokemonOponente) = danioBase
}

object curarse inherits Ataque (nombre = "curarse", danioBase = 0, nombreImagen = "Curarse.png") {
    override method ejecutar(pokemonAtacante, pokemonOponente) {
    pokemonAtacante.agregarVida(20) 
    /* Aca podriamos meter visuales */
    game.say(pokemonAtacante, "¡Me estoy recuperando!")
    }
    /* mientras menos vida tiene mas puntos da el calcular efecto */
    override method calcularEfecto(pokemonAtacante, pokemonOponente) = 1000 / pokemonAtacante.vida() 
}

// Ataques de tipo Agua 
object burbuja inherits Ataque (nombre = "Burbuja", danioBase = 10, nombreImagen = "Burbuja.png") {}
object hidrobomba inherits Ataque (nombre = "Hidrobomba", danioBase = 25, nombreImagen = "Hidrobomba.png") {}
object mordisco inherits Ataque (nombre = "Mordisco", danioBase = 12, nombreImagen = "Mordisco.png") {}
object chorroAgua inherits Ataque (nombre = "Chorro de Agua", danioBase = 18, nombreImagen = "ChorroAgua.png") {}

// Ataques de tipo Fuego
object lanzallamas inherits Ataque(nombre = "Lanzallamas", danioBase = 20, nombreImagen = "Lanzallamas.png") {}
object ascuas inherits Ataque(nombre = "Ascuas", danioBase = 15, nombreImagen = "Ascuas.png") {}
object golpeFuego inherits Ataque(nombre = "Golpe Fuego", danioBase = 12, nombreImagen = "GolpeFuego.png") {}
object colmilloFuego inherits Ataque(nombre = "Colmillo Fuego", danioBase = 18, nombreImagen = "ColmilloFuego.png") {}
object llamarada inherits Ataque(nombre = "Llamarada", danioBase = 22, nombreImagen = "Llamarada.png") {}
object giroFuego inherits Ataque(nombre = "Giro Fuego", danioBase = 18, nombreImagen = "GiroFuego.png") {}


// Ataques de tipo Eléctrico
object trueno inherits Ataque(nombre = "Trueno", danioBase = 18, nombreImagen = "Trueno.png") {}
object impactrueno inherits Ataque(nombre = "Impactrueno", danioBase = 12, nombreImagen = "Impactrueno.png") {}
object electrocanion inherits Ataque(nombre = "Electrocañón", danioBase = 25, nombreImagen = "Electrocanion.png") {}
object rayo inherits Ataque(nombre = "Rayo", danioBase = 15, nombreImagen = "Rayo.png") {}
object chispa inherits Ataque(nombre = "Chispa", danioBase = 10, nombreImagen = "Chispa.png") {}


// Ataques de tipo Planta
object veneno inherits Ataque(nombre = "Veneno", danioBase = 12, nombreImagen = "Veneno.png") {}
object rayoSolar inherits Ataque(nombre = "Rayo Solar", danioBase = 25, nombreImagen = "RayoSolar.png") {}
object latigoCepa inherits Ataque(nombre = "Látigo Cepa", danioBase = 14, nombreImagen = "LatigoCepa.png") {}

object teclasAtaques {
  const property position = game.at(54, 5)
  method image() = "teclasAtaques.png"
}