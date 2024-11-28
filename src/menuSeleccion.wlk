import wollok.game.* // Importa la biblioteca de juego
import masterBatalla.*
import pokemones.*

object pokemonesElegir {
  const position = game.center()
  const equipoJugador = [] // Para almacenar los Pokémon seleccionados
  const equipoComputadora = [] // Para almacenar los Pokémon seleccionados

  var index = 0
  var currentIndex = 0 // Índice actual del Pokémon seleccionado

  const property listaPokemones = [
    squirtle,
    totodile,
    charmander,
    tepig,
    pikachu,
    shinx,
    shaymin,
    bulbasaur
  ] // Lista de Pokémon disponibles

  const listaVisuales = []

  method position() = position
  
  method image() = "FondoPelea.png"

  method iniciar() {
    self.mostrarListaPokemones()
    self.configurarTeclas()
  }

  method mostrarListaPokemones() {
    // Muestra la lista de Pokémon disponibles
    listaPokemones.forEach({pokemon =>  self.crearPokemonVisual(pokemon)}) 
    listaVisuales.get(0).cuadrado().cambiarANaranjaClaro() // para que el primer cuadrado ya arranque marcado de azul
  }

  method configurarTeclas() {
    keyboard.up().onPressDo({
      if (currentIndex > 3) {
        self.cambiarSeleccion(currentIndex - 4) // Mover hacia arriba dentro de la lista
      } else {
        self.cambiarSeleccion(currentIndex + 4) // Si está en la fila superior, ir a la fila inferior
      }
    })

    keyboard.down().onPressDo({
      if (currentIndex < 4) {
        self.cambiarSeleccion(currentIndex + 4) // Mover hacia abajo dentro de la lista
      } else {
        self.cambiarSeleccion(currentIndex - 4) // Si está en la fila inferior, ir a la fila superior
      }
    })

    keyboard.left().onPressDo({
      if (currentIndex % 4 != 0) {
        self.cambiarSeleccion(currentIndex - 1) // Mover hacia la izquierda dentro de la lista
      } else {
        self.cambiarSeleccion(currentIndex + 3) // Si está en el borde izquierdo, ir al borde derecho de la misma fila
      }
    })

    keyboard.right().onPressDo({
      if (currentIndex < 7) {
        self.cambiarSeleccion(currentIndex + 1) // Mover hacia la derecha dentro de la lista
      } else {
        self.cambiarSeleccion(0) // Si está en el borde derecho, ir al borde izquierdo de la misma fila
      }
    })

    // Tecla para confirmar la selección de Pokémon
    keyboard.space().onPressDo({
      self.seleccionarPokemon(currentIndex)
      self.comprobarSeleccionCompleta() // Verifica si ambos equipos están completos
    })
  }

  method moverSeleccionDerecha(newIndex) {
    if (newIndex < 7) {
        self.cambiarSeleccion(newIndex + 1) // Mover hacia la derecha dentro de la lista
      } else {
        self.cambiarSeleccion(0) // Si está en el borde derecho, ir al borde izquierdo de la misma fila
      }
  }

  method moverSeleccionIzquierda(newIndex) {
    if (newIndex > 0) {
        self.cambiarSeleccion(newIndex - 1) // Mover hacia la derecha dentro de la lista
      } else {
        self.cambiarSeleccion(7) // Si está en el borde derecho, ir al borde izquierdo de la misma fila
      }
  }

  method crearPokemonVisual(pokemon) {
    var posX 
    var posY 

    // Calcula las posiciones directamente basadas en el índice
    posX = 10 + (index % 4) * 20 // 4 Pokémon por fila, espaciados a 15
    posY = 10 
    if (index >= 4) posY = 30 

    index = index + 1 // Incrementa el índice global

    // Crear el cuadrado en la posición del Pokémon
    const cuadrado = new Cuadrado(posX = posX, posY = posY)

    // Crear el objeto nombre asociado del Pokémon
    const auxNombre = new Nombre(nombre = pokemon.nombre(), posX =  posX - 5, posY = posY - 5 )

    // Crear un objeto visual para el Pokémon
    const aux = new PokemonVisual(
      nombre = pokemon.nombre(),
      posX = posX, posY = posY,
      cuadrado = cuadrado, 
      imgNombre = auxNombre
    )

    game.addVisual(cuadrado)
    game.addVisual(aux)
    game.addVisual(auxNombre)

    listaVisuales.add(aux)
  }

  method seEncuentraSeleccionado(newIndex) {
    const pokemonSeleccionado = listaPokemones.get(newIndex)
    return equipoJugador.any({p => p == pokemonSeleccionado}) || equipoComputadora.any({p => p == pokemonSeleccionado})
  }

  method seleccionarPokemon(id) {
    if (id >= 0 && id < listaPokemones.size()) {
      const pokemonSeleccionado = listaPokemones.get(id)

      // Reproducir sonido de selección
        const seleccionSound = game.sound("sound_selection.mp3")
        seleccionSound.play()
      // Verifica si el Pokémon ya está en el equipo visualizado y añade a las listas
      if (equipoJugador.size() < 3 && !equipoJugador.contains(pokemonSeleccionado)) {
        equipoJugador.add(pokemonSeleccionado)

        const cuadradoJugador = listaVisuales.get(id).cuadrado()
        cuadradoJugador.cambiarARosa() // Cambia el color del cuadrado a Rosa para el jugador
        
        game.say(game, "Has elegido a " + pokemonSeleccionado.nombre() + " para tu equipo.")
      }
      else if (equipoComputadora.size() < 3 && !equipoComputadora.contains(pokemonSeleccionado)) {
        equipoComputadora.add(pokemonSeleccionado)
        
        const cuadradoComputadora = listaVisuales.get(id).cuadrado()
        cuadradoComputadora.cambiarAAzul() // Cambia el color del cuadrado a Azul para la computadora
        
        game.say(game, "El Pokémon " + pokemonSeleccionado.nombre() + " ha sido asignado al equipo de la computadora.")
      }
    }
  }

  // Método para comprobar si ambos equipos están completos
  method comprobarSeleccionCompleta() {
    if (equipoJugador.size() == 3 && equipoComputadora.size() == 3) {
      game.say(game, "¡Ambos equipos están completos! ¡Comienza la batalla!")
      self.iniciarBatalla() // Llama al inicio de la batalla
    }
  }

  method cambiarSeleccion(newIndex) {
    var pokemonVisual = listaVisuales.get(currentIndex)
    // Cambia el color del cuadrado de la selección anterior
    pokemonVisual.cuadrado().cambiarColorSeleccion() // Desmarca el cuadrado anterior
    
    if (self.seEncuentraSeleccionado(newIndex)) {
      if (currentIndex < newIndex) {
        self.moverSeleccionDerecha(newIndex)
      } else {
        self.moverSeleccionIzquierda(newIndex)
      }
    } else {
      // Actualiza el índice de selección actual
      currentIndex = newIndex
      pokemonVisual = listaVisuales.get(currentIndex)

      // Cambia el color del nuevo cuadrado seleccionado
      pokemonVisual.cuadrado().cambiarANaranjaClaro() // Marca el nuevo cuadrado
    }
  }
  
  method iniciarBatalla() {
    // Remover todas las visuales si es necesario
    listaVisuales.forEach({visual => visual.removerVisuales()})

    /* 
     Logica para desactivar funciones de las teclas
    */

    // Establece la imagen de fondo
    game.boardGround("FondoPelea.png")

    // Enviar los equipos a batalla
    const mainBatalla = new ControladorDeBatalla (
      equipoJugador = equipoJugador,
      equipoComputadora = equipoComputadora)

    mainBatalla.iniciar()
  }
}

class PokemonVisual {
  const property nombre
  const posX  
  const posY  
  const property cuadrado
  const property imgNombre

  const position = game.at(posX, posY)
      
  method position() = position

  method image() = nombre + "Frente" + ".png"

  method removerVisuales() {
    game.removeVisual(cuadrado)
    game.removeVisual(imgNombre)
    game.removeVisual(self)
  }
}

class Cuadrado {
  const posX
  const posY
  var colorImagen = "cuadradoNaranja2.png" // Color inicial
  var property equipo = "ninguno" // Puede ser "jugador", "computadora", o "ninguno"
  const position = game.at(posX, posY)
      
  method position() = position
  method image() = colorImagen

  // Cambia el color a Naranja (inicial)
  method cambiarANaranja() {
    colorImagen = "cuadradoNaranja2.png"
    equipo = "ninguno"
  }

  // Cambia el color a Rosa para el equipo del jugador
  method cambiarARosa() {
    colorImagen = "cuadradoSeleccion.png"
    equipo = "jugador"
  }

  // Cambia el color a Azul para el equipo de la computadora
  method cambiarAAzul() {
    colorImagen = "cuadradoAzul2.png"
    equipo = "computadora"
  }

  // Cambia temporalmente a Naranja Claro para la selección actual
  method cambiarANaranjaClaro() {
    colorImagen = "cuadradoClaro2.png"
  }

  // Cambia temporalmente a Naranja Claro al recorrer, luego restaura el color según el equipo
  method cambiarColorSeleccion() {
    // Restaura el color original basado en el equipo
    if (equipo == "jugador") {
      self.cambiarARosa() // Restaura a Rosa si es del jugador
    } else if (equipo == "computadora") {
      self.cambiarAAzul() // Restaura a Azul si es de la computadora
    } else {
      self.cambiarANaranja() // Restaura a Naranja si no es de ninguno
    }
  }
}

class Nombre{
  const posX
  const posY
  const nombre
  
  const position = game.at(posX, posY)
      
  method position() = position
  
  // Método que devuelve la imagen del cuadrado
  method image() = "Nombre" + nombre + ".png"
}