import wollok.game.*
import pokemones.*
import ataques.*

class ControladorDeBatalla {
  const equipoJugador = []
  const equipoComputadora = []
  var indexPokemonJugador = 0 
  var indexPokemonComputadora = 0

  method iniciar() {
    equipoComputadora.forEach({ pokemon => pokemon.cambiarSide() })
    self.configurarTeclasAtaque()
    game.addVisual(self.pokemonActivoJugador())
    game.addVisual(self.pokemonActivoComputadora())
  }

  // Devuelve el Pokémon activo del equipo del jugador
  method pokemonActivoJugador() {
    return equipoJugador.get(indexPokemonJugador)
  }

  method configurarTeclasAtaque() {
    keyboard.a().onPressDo({ self.ejecutarAtaqueJugador(0) })
    keyboard.s().onPressDo({ self.ejecutarAtaqueJugador(1) })
    keyboard.d().onPressDo({ self.ejecutarAtaqueJugador(2) })
    keyboard.f().onPressDo({ self.ejecutarAtaqueJugador(3) })
  }

  method ejecutarAtaqueJugador(indiceAtaque) {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()

    if (pokemonJugador.vida() > 0) {
      pokemonJugador.ataques().get(indiceAtaque).ejecutar(pokemonJugador, pokemonComputadora)
      self.verificarEstado()
      game.schedule(800, { self.turnoComputadora() })
    }
  }

  method turnoComputadora() {
    const pokemonComputadora = self.pokemonActivoComputadora()
    const pokemonJugador = self.pokemonActivoJugador()

    if (pokemonComputadora.vida() > 0) {
      pokemonComputadora.elegirAtaque(pokemonJugador)
      self.verificarEstado()
    }
  }

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
      keyboard.a().onPressDo(null)
      keyboard.s().onPressDo(null)
      keyboard.d().onPressDo(null)
      keyboard.f().onPressDo(null)

      game.say(game,"¡La batalla ha terminado! Ganador: " + self.determinarGanador())
      if(self.determinarGanador() == "Equipo Computadora") game.addVisual(lose)
      if(self.determinarGanador() == "Equipo Jugador") game.addVisual(win)

      game.schedule(500, {game.stop()})
    } 
  }

  method equipoDerrotado() = (indexPokemonJugador >= equipoJugador.size()) || (indexPokemonComputadora >= equipoComputadora.size())
  
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