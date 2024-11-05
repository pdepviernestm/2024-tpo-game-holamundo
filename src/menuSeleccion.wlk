import wollok.game.* // Importa la biblioteca de juego
import masterBatalla.*
import pokemones.*


object pokemonesElegir {
  const position = game.center()
  // var selectedPokemons = [] // Para almacenar los Pokémon seleccionados
  var index = 0
  const listaPokemones = [
    squirtle,
    totodile,
    charmander,
    tepig,
    pikachu,
    shinx,
    shaymin,
    bulbasaur
  ] // Lista de Pokémon disponibles

  method position() = position
  
  // method image() = "fondo_elegir_pokemon.jpg"
  method image() = "FondoPelea.png"

  method mostrarListaPokemones() {
    // Muestra la lista de Pokémon disponibles
    listaPokemones.forEach({pokemon =>  self.crearPokemonVisual(pokemon)}) 
  }
  
  method crearPokemonVisual(pokemon) {
    var posX 
    var posY 

    // Calcula las posiciones directamente basadas en el índice
    posX = 10 + (index % 4) * 15 // 4 Pokémon por fila, espaciados a 15
    posY = 15 
    if (index >= 4) posY = 30 

    index = index + 1 // Incrementa el índice global

    // Crear el cuadrado en la posición del Pokémon
    const cuadrado = new Cuadrado(posX = posX, posY = posY)
    game.addVisual(cuadrado)


    // Crear un objeto visual para el Pokémon
    const aux = new PokemonVisual(nombre = pokemon.nombre(), posX = posX, posY = posY)
    game.addVisual(aux)

    // Ajusto el Pokemon dentro del Cuadrado
    const offset = 5
    posX = posX - offset 
    posY = posY - offset 

    const auxNombre = new Nombre(nombre = pokemon.nombre(), posX = posX, posY = posY)
    game.addVisual(auxNombre)

  }
  
  
  method iniciarBatalla(equipoJugador, equipoComputadora) {
    // Remover todas las visuales
    // -----
    
    // Establece la imagen de fondo
    game.boardGround("FondoPelea.png")

    // Enviar los equipoos a batalla
    const mainBatalla = new ControladorDeBatalla (
      equipoJugador = equipoJugador,
      equipoComputadora = equipoComputadora)
      // equipoJugador = [squirtle, charmander, pikachu],
      // equipoComputadora = [totodile, tepig, shaymin])

    mainBatalla.iniciar()
  }
  
}

class PokemonVisual {
  const nombre
  const posX  
  const posY  

  const position = game.at(posX, posY)
      
  method position() = position

  method image() = nombre + "Frente" + ".png"

  // Método para mostrar el texto con el nombre del Pokémon
  // method text() = nombre

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
  
  const position = game.at(posX, posY)
      
  method position() = position
  
  // Método que devuelve la imagen del cuadrado
  method image() = "cuadradoNaranja2.png"

}

class Nombre{
  const posX
  const posY
  const nombre
  
  const position = game.at(posX, posY)
      
  method position() = position
  
  // Método que devuelve la imagen del cuadrado
  method image() = "NombrePikachu.png"
}