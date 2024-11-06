import wollok.game.* // Importa la biblioteca de juego
import menuSeleccion.*

object menuInicio {
  var property position = game.center()
  
  method position() = position
  
  method image() = "menu_principal.png"
}

object botonStart {
  method mostrarPokemonesElegir() {
    // game.removeVisual(menuInicio)
    game.boardGround(pokemonesElegir.image())
    
    pokemonesElegir.iniciar()
  }
}