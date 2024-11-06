import wollok.game.*
import pokemones.*
import ataques.*
import tipos.*

class ControladorDeBatalla {
  const equipoJugador = []
  const equipoComputadora = []
  var indexPokemonJugador = 0
  var indexPokemonComputadora = 0
  
  method iniciar() {
    // Cambia el lado de todos los Pokémon de la computadora
    equipoComputadora.forEach({ pokemon => pokemon.cambiarSide() })
    
    game.addVisual(self.pokemonActivoJugador())
    game.addVisual(self.pokemonActivoComputadora())
    self.agregarTeclasAtaques()
    game.addVisual(teclasAtaques)
    self.configurarTeclasAtaque()
  }
  
  // Devuelve el Pokémon activo del equipo del jugador
  method pokemonActivoJugador() = equipoJugador.get(indexPokemonJugador)
  
  // Devuelve el Pokémon activo del equipo de la computadora
  method pokemonActivoComputadora() = equipoComputadora.get(
    indexPokemonComputadora
  )
  
  // Configura teclas para los ataques del Pokémon controlado por el jugador
  method configurarTeclasAtaque() {
    keyboard.a().onPressDo({ self.ejecutarAtaqueJugador(0) })
    keyboard.s().onPressDo({ self.ejecutarAtaqueJugador(1) })
    keyboard.d().onPressDo({ self.ejecutarAtaqueJugador(2) })
    keyboard.f().onPressDo({ self.ejecutarAtaqueJugador(3) })
  }
  
  method agregarTeclasAtaques() {
    const ataques = self.pokemonActivoJugador().ataques()
    ataques.forEach({ ataque => game.addVisual(ataque) })
    ataques.forEach({ ataque => self.enviarPosicion(ataques, ataque) })
  }
  
  method enviarPosicion(ataques, ataque) {
    if (ataque == ataques.get(0)) ataque.cambiarPosicion(0)
    if (ataque == ataques.get(1)) ataque.cambiarPosicion(1)
    if (ataque == ataques.get(2)) ataque.cambiarPosicion(2)
    if (ataque == ataques.get(3)) ataque.cambiarPosicion(3)
  }
  
  // Ejecuta el ataque elegido por el jugador
  method ejecutarAtaqueJugador(indiceAtaque) {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()
    
    if (pokemonJugador.vida() > 0) {
      const ataque = pokemonJugador.ataques().get(indiceAtaque)
      ataque.ejecutar(pokemonJugador, pokemonComputadora)
      const cuadroAtaque = object {
        const property position = game.at(25, 35)
        method image() = "cuadro" + ataque.nombreImagen()
      }
      game.addVisual(cuadroAtaque)
      game.schedule(1500, { game.removeVisual(cuadroAtaque) })
      self.verificarEstado()
      game.schedule(2000, { self.turnoComputadora() })
    }
  }
  
  // Turno automático de la computadora
  method turnoComputadora() {
    const pokemonComputadora = self.pokemonActivoComputadora()
    const pokemonJugador = self.pokemonActivoJugador()
    
    if (pokemonComputadora.vida() > 0) {
      pokemonComputadora.elegirAtaque(pokemonJugador)
      const ataque = pokemonComputadora.elegirAtaque(pokemonJugador)
      const cuadroAtaque = object {
        const property position = game.at(25, 35)
        method image() = "cuadro" + ataque.nombreImagen()
      }
      game.addVisual(cuadroAtaque)
      game.schedule(1500, { game.removeVisual(cuadroAtaque) })
      self.verificarEstado()
    }
  }
  
  // Verifica si alguno de los Pokémon fue derrotado y avanza en la lista
  method verificarEstado() {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()
    if (pokemonJugador.vida() <= 0) {
      game.removeVisual(pokemonJugador)
      pokemonJugador.ataques().forEach({ ataque => game.removeVisual(ataque) })
      indexPokemonJugador += 1
      if (indexPokemonJugador < equipoJugador.size()) {
        game.addVisual(self.pokemonActivoJugador())
        self.agregarTeclasAtaques()
      }
    }
    if (pokemonComputadora.vida() <= 0) {
      game.removeVisual(pokemonComputadora)
      indexPokemonComputadora += 1
      if (indexPokemonComputadora < equipoComputadora.size()) game.addVisual(
          self.pokemonActivoComputadora()
        )
    }
    if (self.equipoDerrotado()) {
      // Desactivar teclas al finalizar la batalla
      self.desactivarTeclas()
      pokemonJugador.ataques().forEach({ ataque => game.removeVisual(ataque) })
      game.removeVisual(teclasAtaques)
      
      game.say(
        game,
        "¡La batalla ha terminado! Ganador: " + self.determinarGanador()
      )
      if (self.determinarGanador() == "Equipo Computadora") game.addVisual(lose)
      if (self.determinarGanador() == "Equipo Jugador") game.addVisual(win)
      
      game.schedule(1500, { game.stop() })
    }
  }
  
  method desactivarTeclas() {
    keyboard.a().onPressDo({   })
    keyboard.s().onPressDo({   })
    keyboard.d().onPressDo({   })
    keyboard.f().onPressDo({   })
  }
  
  // Verifica si alguno de los equipos ha sido derrotado
  method equipoDerrotado() = (indexPokemonJugador >= equipoJugador.size()) || (indexPokemonComputadora >= equipoComputadora.size())
  
  // Determina el equipo ganador
  method determinarGanador() {
    if (indexPokemonJugador >= equipoJugador.size()) {
      return "Equipo Computadora"
    } else {
      return "Equipo Jugador"
    }
  }
}

object win {
  const position = game.at(25, 15)
  
  method position() = position
  
  method image() = "win.png"
}

object lose {
  const position = game.at(25, 15)
  
  method position() = position
  
  method image() = "lose.png"
}