import wollok.game.*
import pokemones.*
import ataques.*

class ControladorDeBatalla {
  const equipoJugador = []
  const equipoComputadora = []
  var indexPokemonJugador = 0 
  var indexPokemonComputadora = 0

  method iniciar() {
    // Cambia el lado de todos los Pokémon de la computadora
    equipoComputadora.forEach({ pokemon => pokemon.cambiarSide() })

    self.configurarTeclasAtaque()
    game.addVisual(self.pokemonActivoJugador())
    game.addVisual(self.pokemonActivoComputadora())
  }

  // Devuelve el Pokémon activo del equipo del jugador
  method pokemonActivoJugador() {
    return equipoJugador.get(indexPokemonJugador)
  }

  // Devuelve el Pokémon activo del equipo de la computadora
  method pokemonActivoComputadora() {
    return equipoComputadora.get(indexPokemonComputadora)
  }

  // Configura teclas para los ataques del Pokémon controlado por el jugador
  method configurarTeclasAtaque() {
    keyboard.a().onPressDo({ self.ejecutarAtaqueJugador(0) })
    keyboard.s().onPressDo({ self.ejecutarAtaqueJugador(1) })
    keyboard.d().onPressDo({ self.ejecutarAtaqueJugador(2) })
    keyboard.f().onPressDo({ self.ejecutarAtaqueJugador(3) })
  }

  // Ejecuta el ataque elegido por el jugador
  method ejecutarAtaqueJugador(indiceAtaque) {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()

    if (pokemonJugador.vida() > 0) {
      pokemonJugador.ataques().get(indiceAtaque).ejecutar(pokemonJugador, pokemonComputadora)
      self.verificarEstado()
      game.schedule(800, { self.turnoComputadora() })
    }
  }

  // Turno automático de la computadora
  method turnoComputadora() {
    const pokemonComputadora = self.pokemonActivoComputadora()
    const pokemonJugador = self.pokemonActivoJugador()

    if (pokemonComputadora.vida() > 0) {
      pokemonComputadora.elegirAtaque(pokemonJugador)
      self.verificarEstado()
    }
  }

  // Verifica si alguno de los Pokémon fue derrotado y avanza en la lista
  method verificarEstado() {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()
    if (pokemonJugador.vida() <= 0) {
      game.removeVisual(pokemonJugador)
      indexPokemonJugador += 1 
      if (indexPokemonJugador < equipoJugador.size()) {
        game.addVisual(self.pokemonActivoJugador())
      }
    }
    if (pokemonComputadora.vida() <= 0) {
      game.removeVisual(pokemonComputadora)
      indexPokemonComputadora += 1
      if (indexPokemonComputadora < equipoComputadora.size()) {
        game.addVisual(self.pokemonActivoComputadora())
      }
    }
    if (self.equipoDerrotado()) {
      // Desactivar teclas al finalizar la batalla
      keyboard.a().onPressDo(null)
      keyboard.s().onPressDo(null)
      keyboard.d().onPressDo(null)
      keyboard.f().onPressDo(null)

      game.say(game,"¡La batalla ha terminado! Ganador: " + self.determinarGanador())
      if(self.determinarGanador() == "Equipo Computadora") game.addVisual(lose)
      if(self.determinarGanador() == "Equipo Jugador") game.addVisual(win)

      game.schedule(100, {game.stop()})
    } 
  }

  // Verifica si alguno de los equipos ha sido derrotado
  method equipoDerrotado() {
    return indexPokemonJugador >= equipoJugador.size() || indexPokemonComputadora >= equipoComputadora.size()
  }

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
  const position = game.at(25,15)
  
  method position() = position
  
  method image() = "win.png"
}
object lose {
  const position = game.at(25,15)
  
  method position() = position
  
  method image() = "lose.png"
}