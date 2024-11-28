import tipos.*
import wollok.game.*
import ataques.*


class Pokemon {
  const nombre
  const property tipo
  var property vida = 100
  const property ataques = []

  var property side = "Frente"
  var atacando = false
  
  method image() = (nombre + side) + ".png"
  
  method nombre() = nombre
  
  method posicionLejos() = game.at(60, 20)

  method posicionCerca() = game.at(25, 8)

  method position() {
    if (side == "Frente") {
      return if(atacando) self.posicionCerca() else self.posicionLejos()
    } else {
      return if(atacando) self.posicionLejos() else self.posicionCerca()
    }
  }
  
  method cambiarSide() {
    side = if (side == "Frente") "Espalda" else "Frente"
  }
  
  method irAtacar() {
    atacando = true
  }
  
  method volverDeAtacar() {
    atacando = false
  }
  
  method recibirDanio(danio) {
    vida = (vida - danio).max(0)
  }
  
  method agregarVida(nuevaVida) {
    vida += nuevaVida
  }
  
  // Método para elegir el ataque mayor efecto
  method elegirAtaque(pokemonOponente) {
    const mejorAtaque = ataques.max(
      { ataque => ataque.calcularEfecto(self, pokemonOponente) }
    )
    mejorAtaque.ejecutar(self, pokemonOponente)
    return mejorAtaque
  }
} 

/* Agua */
object squirtle inherits Pokemon (
  nombre = "Squirtle",
  tipo = agua,
  ataques = [golpeSeco, burbuja, hidrobomba, curarse]
) {
  
}

object totodile inherits Pokemon (
  nombre = "Totodile",
  tipo = agua,
  ataques = [golpeSeco, mordisco, chorroAgua, curarse]
) {
  
} /* Fuego */

object charmander inherits Pokemon (
  nombre = "Charmander",
  tipo = fuego,
  ataques = [golpeSeco, lanzallamas, ascuas, golpeFuego]
) {
  
}

object tepig inherits Pokemon (
  nombre = "Tepig",
  tipo = fuego,
  ataques = [golpeSeco, colmilloFuego, llamarada, giroFuego]
) {
  
} /* Electrico */

object pikachu inherits Pokemon (
  nombre = "Pikachu",
  tipo = electrico,
  ataques = [golpeSeco, trueno, impactrueno, electrocanion]
) {
  
}

object shinx inherits Pokemon (
  nombre = "Shinx",
  tipo = electrico,
  ataques = [golpeSeco, rayo, chispa, trueno]
) {
  
} /* Planta */

object shaymin inherits Pokemon (
  nombre = "Shaymin",
  tipo = planta,
  ataques = [golpeSeco, veneno, rayoSolar, curarse]
) {
  
}

object bulbasaur inherits Pokemon (
  nombre = "Bulbasaur",
  tipo = planta,
  ataques = [golpeSeco, latigoCepa, veneno, curarse]
) {
  
}