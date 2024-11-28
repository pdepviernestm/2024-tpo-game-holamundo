import wollok.game.*
import pokemones.*
import ataques.*
import tipos.*

class ControladorDeBatalla {
  const equipoJugador
  const equipoComputadora
  var indexPokemonJugador = 0 
  var indexPokemonComputadora = 0


  // Define la música de fondo
  const musicaFondo = game.sound("Pokemon_batalla_sound.mp3")

  // Método para iniciar el juego y configurar todo
  method iniciar() {

    // Configurar la música de fondo
    musicaFondo.shouldLoop(true)
    musicaFondo.play()

    equipoComputadora.forEach({ pokemon => pokemon.cambiarSide() })
    
    game.addVisual(self.pokemonActivoJugador())
    game.addVisual(self.pokemonActivoComputadora())
    self.actualizarImagenVidaJugador()
    self.actualizarImagenVidaComputadora()
    self.agregarTeclasAtaques()
    game.addVisual(teclasAtaques)
    self.configurarTeclasAtaque()
  }
  
   // Método para detener la música de fondo al finalizar la batalla
  method finalizarBatalla() {
    musicaFondo.stop() // Detiene la música de fondo
  }

  // Devuelve el Pokémon activo del equipo del jugador
  method pokemonActivoJugador() = equipoJugador.get(indexPokemonJugador)
  
  // Devuelve el Pokémon activo del equipo de la computadora
  method pokemonActivoComputadora() = equipoComputadora.get(indexPokemonComputadora)

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
    

    if (pokemonJugador.vida() > 0 && indiceAtaque < pokemonJugador.ataques().size()) {
      const ataque = pokemonJugador.ataques().get(indiceAtaque)
      ataque.ejecutar(pokemonJugador, pokemonComputadora)
      const cuadroAtaque = object {
        const property position = game.at(10, 35)
        method image() = "cuadro" + ataque.nombreImagen()
      }
      game.addVisual(cuadroAtaque)
      game.schedule(1500, { game.removeVisual(cuadroAtaque) })
      self.verificarEstado()
      self.actualizarImagenVidaJugador()
      self.actualizarImagenVidaComputadora()
      game.schedule(2000, { self.turnoComputadora() })
    } else {
      game.removeVisual(vidaJugador) 
    }
  }

  method turnoComputadora() {
    const pokemonComputadora = self.pokemonActivoComputadora()
    const pokemonJugador = self.pokemonActivoJugador()
    
    
    if (pokemonComputadora.vida() > 0) {
      const ataque = pokemonComputadora.elegirAtaque(pokemonJugador)
      const cuadroAtaque = object {
        const property position = game.at(25, 35)
        method image() = "cuadro" + ataque.nombreImagen()
      }
      game.addVisual(cuadroAtaque)
      game.schedule(1500, { game.removeVisual(cuadroAtaque) })
      
      self.verificarEstado()
      self.actualizarImagenVidaJugador()
      self.actualizarImagenVidaComputadora()
    }
  }
  
  // Verifica si alguno de los Pokémon fue derrotado y avanza en la lista
  method verificarEstado() {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()
    
    if (pokemonJugador.vida() <= 0) {
      game.removeVisual(pokemonJugador)
      game.removeVisual(vidaJugador)
      pokemonJugador.ataques().forEach({ ataque => game.removeVisual(ataque) })
      indexPokemonJugador += 1
      if (indexPokemonJugador < equipoJugador.size()) {
        game.addVisual(self.pokemonActivoJugador())
        self.agregarTeclasAtaques()
      }
    }
    
    if (pokemonComputadora.vida() <= 0) {
      game.removeVisual(pokemonComputadora)
      game.removeVisual(vidaComputadora)
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
      
      const winloseSound = game.sound("Win_sound.mp3")

      if (self.determinarGanador() == "Equipo Computadora") game.addVisual(lose)
      if (self.determinarGanador() == "Equipo Jugador") game.addVisual(win) 

      winloseSound.play()

      // Detener la música de fondo
      self.finalizarBatalla()
      
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
  
  method actualizarImagenVida(pokemon) {
    const nuevaImagenVida = self.obtenerImagenVida(pokemon.vida())
    if (pokemon.side() == "Frente") {
      game.removeVisual(vidaJugador)
      vidaJugador.setImage(nuevaImagenVida)
      game.addVisual(vidaJugador)
    } else {
      game.removeVisual(vidaComputadora)
      vidaComputadora.setImage(nuevaImagenVida)
      game.addVisual(vidaComputadora)
    }
  }

  method actualizarImagenVidaJugador() {
    self.actualizarImagenVida(self.pokemonActivoJugador())
  }
  
  method actualizarImagenVidaComputadora() {
    self.actualizarImagenVida(self.pokemonActivoComputadora())
  }
  
  method obtenerImagenVida(vida) { 
    if (vida == 100) {
      return "100_vida.png"
    } else if (vida >= 80) {
      return "80_vida.png"
    } else if (vida >= 60) {
      return "60_vida.png"
    } else if (vida >= 40) {
      return "40_vida.png"
    } else if (vida > 0) {
      return "20_vida.png"
    } else (vida <= 0) {
      return "0_vida.png"
    }
  }
}

object win {
  const position = game.at(35, 20)
  
  method position() = position
  
  method image() = "win.png"
}

object lose {
  const position = game.at(35, 20)
  
  method position() = position
  
  method image() = "lose.png"
}

object vidaJugador {
  const position = game.at(64, 32)
  var image = "100_vida.png"
  
  method position() = position
  
  method image() = image
  
  method setImage(newImage) {
    image = newImage
  }
}

object vidaComputadora {
  const position = game.at(31, 21)
  var image = "100_vida.png"
  
  method position() = position
  
  method image() = image
  
  method setImage(newImage) {
    image = newImage
  }
}
