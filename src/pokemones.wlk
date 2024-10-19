import tipos.*

class Pokemon {
  var nombre
  var tipo
  var vida = 200
  
  // Metodo para calcular la efectividad del ataque
  method efectividad(tipoAtacante, tipoOponente) {
    if (tipoAtacante == tipoOponente) {
      return 0.5
    } else {
      if (tipoOponente.debilidad().contains(tipoAtacante.tipo())) {
        return 2
      } else {
        return 1
      }
    }
  }
  
  // Metodo de ataque generico, usado para todos los ataques
  method atacar(pokemonOponente, danioBase) {
    const efectividad_ataque = self.efectividad(tipo, pokemonOponente.tipo())
    const danioTotal = danioBase * efectividad_ataque
    pokemonOponente.recibirDanio(danioTotal)
  }
  
  // Ataque comun: Golpe Seco
  method golpeSeco(pokemonOponente) {
    pokemonOponente.recibirDanio(10) // Danio base de Golpe Seco es 10
  }
  
  // Metodo para recibir danio
  method recibirDanio(danio) {
    vida = (vida - danio).max(0)
  }
} /* Agua */

object squirtle inherits Pokemon (nombre = "Squirtle", tipo = agua) {
  method burbuja(pokemonOponente) {
    self.atacar(pokemonOponente, 10) // Danio base de Burbuja es 10
  }
  
  method hidrobomba(pokemonOponente) {
    self.atacar(pokemonOponente, 25) // Danio base de Hidrobomba es 25
  }
  
  // Metodo para curarse
  method curarse() {
    vida += 20
  }
}

object totodile inherits Pokemon (nombre = "Totodile", tipo = agua) {
  method mordisco(pokemonOponente) {
    self.atacar(pokemonOponente, 12) // Danio base de Mordisco es 12
  }
  
  method chorroAgua(pokemonOponente) {
    self.atacar(pokemonOponente, 18) // Danio base de Chorro Agua es 18
  }
  
  // Metodo para curarse
  method curarse() {
    vida += 20
  }
} /* Fuego */

object charmander inherits Pokemon (nombre = "Charmander", tipo = fuego) {
  method lanzallamas(pokemonOponente) {
    self.atacar(pokemonOponente, 20) // Danio base de Lanzallamas es 20
  }
  
  method ascuas(pokemonOponente) {
    self.atacar(pokemonOponente, 15) // Danio base de Ascuas es 15
  }
  
  method golpeFuego(pokemonOponente) {
    self.atacar(pokemonOponente, 12) // Danio base de Golpe Fuego es 12
  }
}

object tepig inherits Pokemon (nombre = "Tepig", tipo = fuego) {
  method colmilloFuego(pokemonOponente) {
    self.atacar(pokemonOponente, 18) // Danio base de Colmillo Fuego es 18
  }
  
  method llamarada(pokemonOponente) {
    self.atacar(pokemonOponente, 22) // Danio base de Llamarada es 22
  }
  
  method giroFuego(pokemonOponente) {
    self.atacar(pokemonOponente, 18) // Danio base de Giro Fuego es 18
  }
} /* Electrico */

object pikachu inherits Pokemon (nombre = "Pikachu", tipo = electrico) {
  method trueno(pokemonOponente) {
    self.atacar(pokemonOponente, 18) // Danio base de Trueno es 18
  }
  
  method impactrueno(pokemonOponente) {
    self.atacar(pokemonOponente, 12) // Danio base de Impactrueno es 12
  }
  
  method electrocanion(pokemonOponente) {
    self.atacar(pokemonOponente, 25) // Danio base de Electrocanion es 25
  }
}

object shinx inherits Pokemon (nombre = "Shinx", tipo = electrico) {
  method rayo(pokemonOponente) {
    self.atacar(pokemonOponente, 15) // Danio base de Rayo es 15
  }
  
  method chispa(pokemonOponente) {
    self.atacar(pokemonOponente, 10) // Danio base de Chispa es 10
  }
  
  method trueno(pokemonOponente) {
    self.atacar(pokemonOponente, 18) // Danio base de Trueno es 18
  }
} /* Planta */

object shaymin inherits Pokemon (nombre = "Shaymin", tipo = planta) {
  method veneno(pokemonOponente) {
    self.atacar(pokemonOponente, 12) // Danio base de Veneno es 12
  }
  
  method rayoSolar(pokemonOponente) {
    self.atacar(pokemonOponente, 25) // Danio base de Rayo Solar es 25
  }
  
  method curarse() {
    vida += 20
  }
}

object bulbasaur inherits Pokemon (nombre = "Bulbasaur", tipo = planta) {
  method latigoCepa(pokemonOponente) {
    self.atacar(pokemonOponente, 14) // Danio base de Latigo Cepa es 14
  }
  
  method veneno(pokemonOponente) {
    self.atacar(pokemonOponente, 12) // Danio base de Veneno es 12
  }
  
  method curarse() {
    vida += 20
  }
}