import tipos.*
import wollok.game.*

class Ataque {
  const property nombre
  const danioBase

  // Método que cada ataque debe implementar
  method ejecutar(pokemonAtacante, pokemonOponente) {
    game.say(pokemonAtacante, "Ejecuta Ataque " + self.nombre())
    pokemonAtacante.irAtacar() // Semaforo para que se acerque a su oponente
    
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
}

// Ataques genericos
object golpeSeco inherits Ataque (nombre = "Golpe Seco", danioBase = 10) {
  override  method calcularEfecto(pokemonAtacante, pokemonOponente) = danioBase
}

object curarse inherits Ataque (nombre = "curarse", danioBase = 0) {
    override method ejecutar(pokemonAtacante, pokemonOponente) {
    pokemonAtacante.agregarVida(20) 
    /* Aca podriamos meter visuales */
    game.say(pokemonAtacante, "¡Me estoy recuperando!")
    }
    /* mientras menos vida tiene mas puntos da el calcular efecto */
    override method calcularEfecto(pokemonAtacante, pokemonOponente) = 1000 / pokemonAtacante.vida() 
}

// Ataques de tipo Agua 
object burbuja inherits Ataque (nombre = "Burbuja", danioBase = 10) {}
object hidrobomba inherits Ataque (nombre = "Hidrobomba", danioBase = 25) {}
object mordisco inherits Ataque (nombre = "mordisco", danioBase = 12) {}
object chorroAgua inherits Ataque (nombre = "mordisco", danioBase = 18) {}

// Ataques de tipo Fuego
object lanzallamas inherits Ataque(nombre = "Lanzallamas", danioBase = 20) {}
object ascuas inherits Ataque(nombre = "Ascuas", danioBase = 15) {}
object golpeFuego inherits Ataque(nombre = "Golpe Fuego", danioBase = 12) {}
object colmilloFuego inherits Ataque(nombre = "Colmillo Fuego", danioBase = 18) {}
object llamarada inherits Ataque(nombre = "Llamarada", danioBase = 22) {}
object giroFuego inherits Ataque(nombre = "Giro Fuego", danioBase = 18) {}


// Ataques de tipo Eléctrico
object trueno inherits Ataque(nombre = "Trueno", danioBase = 18) {}
object impactrueno inherits Ataque(nombre = "Impactrueno", danioBase = 12) {}
object electrocanion inherits Ataque(nombre = "Electrocañón", danioBase = 25) {}
object rayo inherits Ataque(nombre = "Rayo", danioBase = 15) {}
object chispa inherits Ataque(nombre = "Chispa", danioBase = 10) {}


// Ataques de tipo Planta
object veneno inherits Ataque(nombre = "Veneno", danioBase = 12) {}
object rayoSolar inherits Ataque(nombre = "Rayo Solar", danioBase = 25) {}
object latigoCepa inherits Ataque(nombre = "Látigo Cepa", danioBase = 14) {}