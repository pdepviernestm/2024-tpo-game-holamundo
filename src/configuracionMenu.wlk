import wollok.game.* // Importa la biblioteca de juego
import pokemones.* // Importa objetos de Pokémon

object menuInicio {
  var property position = game.center()
  
  method position() = position
  
  method image() = "menu_principal.png"
}

object botonStart {
  var property position = game.at(22, 1)
  
  method image() = "start2.png"
  
  method mostrarPokemonesElegir() {
    game.boardGround(pokemonesElegir.image())
    game.removeVisual(self) // Elimina el botón
    game.addVisual(pokemonesElegir)
  }
}

object estadioPokemon {
  const position = game.center()
  
  method position() = position
  
  method image() = "FondoPelea.png"
}

object pokemonesElegir {
  const position = game.center()
  
  method position() = position
  
  method image() = "fondo_elegir_pokemon.jpg"
}

class Cuadrado {
  // Propiedades
  const posX
  const posY
  
  method posicionarPokemonCuadrado(pokemon) {
    // Establece la posición del Pokémon en la misma posición que el cuadrado
    pokemon.cambiarPosicion(posX, posY)
    game.addVisual(pokemon) // Agrega el Pokémon a la visualización del juego
  }
  
  // Método que devuelve la imagen del cuadrado
  method image() = "cuadradoNaranja.png"
  
  // Método para dibujar el cuadrado
  method draw() {
    game.addVisual(self) // Añade el cuadrado al juego
  }
}