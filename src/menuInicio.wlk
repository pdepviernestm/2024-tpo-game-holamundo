import wollok.game.* // Importa la biblioteca de juego
import menuSeleccion.*

object menuInicio {
  method iniciar() {

    self.configGame()

    game.addVisual(botonStart)

    keyboard.space().onPressDo({ botonStart.mostrarPokemonesElegir() })
  }

  method configGame() {
    game.height(50)
    game.width(100)
    game.title("Batalla Pokemon")
    game.boardGround("FondoPelea.png")
  }

}

object botonStart {
  method position() = game.at(0, -5)
  
  method image() = "FondoInicio2.png"

  method mostrarPokemonesElegir() {
    game.removeVisual(self)

    pokemonesElegir.iniciar()
  }
  
}