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
  
  
  method finalizarBatalla() {
    
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
    const index = self.obtenerIndice(ataques, ataque)
    if (index >= 0) {
      ataque.cambiarPosicion(index)
    }
  }

  method obtenerIndice(array, valor) {
    var indice = -1
    var i = 0
    array.forEach({ elemento =>
        if (elemento == valor) {
          indice = i
        } else{
          i += 1
        }
      })
    return indice
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
      musicaFondo.stop()
      
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
  method determinarGanador() = if (indexPokemonJugador >= equipoJugador.size()) "Equipo Computadora" else "Equipo Jugador"

  method actualizarImagenVidaJugador(){
    vidaJugador.actualizarImagen(self.pokemonActivoJugador().vida())
  }

  method actualizarImagenVidaComputadora() {
    vidaComputadora.actualizarImagen(self.pokemonActivoComputadora().vida())
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

class Vida{
  var image =  "100_vida.png"

  method position() 

  method image() = image
  
  method setImage(newImage) {
    image = newImage
  }

  method actualizarImagen(vidaPokemon) {
    const nuevaImagenVida = self.obtenerImagenVida(vidaPokemon)
    game.removeVisual(self)
    self.setImage(nuevaImagenVida)
    game.addVisual(self)
  }

  method obtenerImagenVida(vida) {
    const rango = if (vida <= 0) 0 else (vida / 20).div(1) * 20
    return rango.toString() + "_vida.png"
  }
}

object vidaJugador inherits Vida  {
  override method position() = game.at(64, 32)
}

object vidaComputadora inherits Vida{
  override method position() = game.at(31, 21)
}
