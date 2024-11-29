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
    musicaFondo.shouldLoop(true)
    musicaFondo.play()

    equipoComputadora.forEach({ pokemon => pokemon.cambiarSide() })
    
    game.addVisual(self.pokemonActivoJugador())
    game.addVisual(vidaJugador)

    game.addVisual(self.pokemonActivoComputadora())
    game.addVisual(vidaComputadora)

    self.configurarTeclasAtaque()
  }

  // Devuelve el Pokémon activo del equipo del jugador
  method pokemonActivoJugador() = equipoJugador.get(indexPokemonJugador)
  
  // Devuelve el Pokémon activo del equipo de la computadora
  method pokemonActivoComputadora() = equipoComputadora.get(indexPokemonComputadora)

  // Ejecuta el ataque elegido por el jugador
  method ejecutarAtaqueJugador(indiceAtaque) {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()
    
    if (pokemonJugador.vida() > 0) {
      const ataque = pokemonJugador.ataques().get(indiceAtaque)
      
      ataque.ejecutar(pokemonJugador, pokemonComputadora)

      cuadroJugador.setearNombre(ataque.nombreImagen())

      self.verificarEstado()

      game.schedule(1200, { self.turnoComputadora() })
    } 
  }

  method turnoComputadora() {
    const pokemonComputadora = self.pokemonActivoComputadora()
    const pokemonJugador = self.pokemonActivoJugador()
    
    if (pokemonComputadora.vida() > 0) {
      const ataque = pokemonComputadora.elegirAtaque(pokemonJugador)

      cuadroComputadora.setearNombre(ataque.nombreImagen())
      
      self.verificarEstado()
    }
  }
  
  // Verifica si alguno de los Pokémon fue derrotado y avanza en la lista
  method verificarEstado() {
    const pokemonJugador = self.pokemonActivoJugador()
    const pokemonComputadora = self.pokemonActivoComputadora()
    
    // Verifica si el Pokémon del jugador ha sido derrotado
    if (pokemonJugador.vida() <= 0) {
      game.removeVisual(pokemonJugador)
      pokemonJugador.ataques().forEach({ ataque => game.removeVisual(ataque) })

      indexPokemonJugador += 1
      
      if(indexPokemonJugador < equipoJugador.size()) {
        self.agregarBotonesAtaques()
        game.addVisual(self.pokemonActivoJugador())
      }else{
        self.terminarBatalla("lose")
      }
    }
    
    // Verifica si el Pokémon de la computadora ha sido derrotado
    if (pokemonComputadora.vida() <= 0) {
      game.removeVisual(pokemonComputadora)

      indexPokemonComputadora += 1

      if (indexPokemonComputadora < equipoComputadora.size()) {
        game.addVisual(self.pokemonActivoComputadora())
      } else{
        pokemonJugador.ataques().forEach({ ataque => game.removeVisual(ataque) })
        self.terminarBatalla("win")
      }
    }
    
    self.actualizarImagenJugador()
    self.actualizarImagenComputadora()
    
  }

  method terminarBatalla(resultado) {
      musicaFondo.stop()
      self.desactivarTeclas()
      game.removeVisual(teclas)

      visualFinal.setter(resultado) 
      
      const winloseSound = game.sound("Win_sound.mp3")
      winloseSound.play()
      
      game.schedule(1500, { game.stop() })
  }
  
  // Verifica si alguno de los equipos ha sido derrotado
  method equipoDerrotado() = (indexPokemonJugador >= equipoJugador.size()) || (indexPokemonComputadora >= equipoComputadora.size())
  
  // Determina el equipo ganador
  method determinarGanador() = if (indexPokemonJugador >= equipoJugador.size()) "Equipo Computadora" else "Equipo Jugador"

  method actualizarImagenJugador(){
    vidaJugador.actualizarImagen(self.pokemonActivoJugador().vida())
  }

  method actualizarImagenComputadora() {
    vidaComputadora.actualizarImagen(self.pokemonActivoComputadora().vida())
  }

  method agregarBotonesAtaques() {
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

  const listTeclas = [keyboard.a(), keyboard.s(), keyboard.d(), keyboard.f()]
  method desactivarTeclas() = listTeclas.forEach{ tecla => tecla.onPressDo{} }
  method configurarTeclasAtaque() {
    listTeclas.forEach{ tecla => tecla.onPressDo{ self.ejecutarAtaqueJugador(self.obtenerIndice(listTeclas, tecla)) } }
    game.addVisual(teclas)
    self.agregarBotonesAtaques()
  }

  method obtenerIndice(array, valor) {
    var indice = -1
    var i = 0
    array.forEach({ elemento =>
        if (elemento == valor) 
          indice = i
         else
          i += 1
        })
    return indice
  }
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
    self.setImage(nuevaImagenVida)
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

class Cuadro{
  var image = ""

  method position() 

  method image() = image

  method setearNombre(nuevoNombre){
    image = "cuadro" + nuevoNombre
    game.addVisual(self)
    game.schedule(500, { game.removeVisual(self) })
  }
}

object cuadroJugador inherits Cuadro {
   override method position() = game.at(10, 35)
}

object cuadroComputadora inherits Cuadro {
   override method position() = game.at(25, 35)
}


object visualFinal {
  var image =  ""
  method position() = game.at(35, 20)

  method image() = image

  method setter(resultado) {
    image = resultado + ".png"
    game.addVisual(self)
  }
}