import wollok.game.* // Importa la biblioteca de juego
import menuSeleccion.*

object menuInicio {
  var property position = game.center()
  
  method position() = position
  
  method image() = "menu_principal.png"
}

object botonStart {
  var property position = game.at(22, 1)
  
  method image() = "start2.png"
  
  method mostrarPokemonesElegir() {
    game.removeVisual(self) // Elimina el botón
    game.boardGround(pokemonesElegir.image())
    
    // Llamar al método para mostrar la lista de Pokémon
    pokemonesElegir.mostrarListaPokemones()
  }
}