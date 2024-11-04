import wollok.game.* // Importa la biblioteca de juego

object pokemonesElegir {
  const position = game.center()
  // var selectedPokemons = [] // Para almacenar los Pokémon seleccionados
  var index = 0
  const listaPokemones = [
    "Squirtle",
    "Totodile",
    "Charmander",
    "Tepig",
    "Pikachu",
    "Shinx",
    "Shaymin",
    "Bulbasaur"
  ] // Lista de Pokémon disponibles

  method position() = position
  
  method image() = "fondo_elegir_pokemon.jpg"

  method mostrarListaPokemones() {
    // Muestra la lista de Pokémon disponibles
    listaPokemones.forEach({pokemon =>  game.addVisual(self.crearPokemonVisual(pokemon))}) 
  }
  
  method crearPokemonVisual(nombre) {
    var posX 
    var posY 

    // Calcula las posiciones directamente basadas en el índice
    posX = 10 + (index % 4) * 15 // 4 Pokémon por fila, espaciados a 15
    if (index >= 4){
      posY = 30 
    } else {
      posY = 15 
    }

    index = index + 1 // Incrementa el índice global

    // Crear un objeto visual para el Pokémon
    const aux = new PokemonVisual(nombre = nombre, posX = posX, posY = posY)
    return aux
    }
  
  
  method iniciarBatalla(nombrePokemon) {
    // Aquí puedes iniciar la lógica de batalla con el Pokémon seleccionado
    // Por ejemplo, crear un objeto ControladorDeBatalla y pasar el Pokémon seleccionado
  }
  
}

class PokemonVisual {
  const nombre
  const posX  
  const posY  

  const position = game.at(posX, posY)
      
  method position() = position

  method image() = nombre + "Frente" + ".png"
       
  method onPressDo() {
    // Lógica para seleccionar el Pokémon
    /*
    if (pokemonesElegir.selectedPokemons.size() < 3 && !pokemonesElegir.selectedPokemons.contains(nombre)) {
      pokemonesElegir.selectedPokemons.add(nombre)
      game.say(game, "Has elegido " + nombre)
      pokemonesElegir.mostrarSeleccionados()
    } else {
      game.say(game, "Ya seleccionaste 3 Pokémon o este Pokémon ya fue elegido.")
    }
    */
    }
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