import tipos.*
import wollok.game.*
import ataques.*


class Pokemon {
  const nombre
  const property tipo
  const property ataques = []

  var property vida = 200
  var property side = "Frente"
  var atacando = 0  // la idea es que funcionen como un semaforo para la posicion de objeto
  
  method image() = nombre + side + ".png"

  method position (){
    if (atacando == 0){
      if (side == "Frente"){
          return game.at(60,20)
      } else{
          return game.at(25,8)
      }
    } else{ /* Si esta atacando se acerca al oponente y luego vuelve */
      if (side == "Frente"){
        return game.at(25,8)
      } else{
        return game.at(60,20)
      }
    }
	}

  method cambiarSide() {
    if (side == "Frente"){
			side = "Espalda"
		}else{
			side = "Frente"
		}
  }
  
  method irAtacar() {
    atacando = 1
    }
  method volverDeAtacar() {
    atacando = 0
  }

  // Metodo para recibir danio
  method recibirDanio(danio) {
  vida = (vida - danio).max(0)
  
  }

  method agregarVida(nuevaVida) {
    vida = vida + nuevaVida
  }
  
  method terminarTurno() {
    // self.cambiarSide()
  }

  // Método para elegir el ataque mayor efecto
  method elegirAtaque(pokemonOponente) {
    const mejorAtaque = ataques.max({ataque => ataque.calcularEfecto(self, pokemonOponente)})
    mejorAtaque.ejecutar(self, pokemonOponente)
 } 
}

/* Agua */
object squirtle inherits Pokemon (nombre = "Squirtle", tipo = agua ,
  ataques = [golpeSeco, burbuja, hidrobomba, curarse]) {}

object totodile inherits Pokemon (nombre = "Totodile", tipo = agua, 
  ataques = [golpeSeco, mordisco, chorroAgua, curarse]) {} 

/* Fuego */
object charmander inherits Pokemon (nombre = "Charmander", tipo = fuego,
  ataques = [golpeSeco, lanzallamas, ascuas, golpeFuego]) {}

object tepig inherits Pokemon (nombre = "Tepig", tipo = fuego,
  ataques = [golpeSeco, colmilloFuego, llamarada, giroFuego]) {} 
                  
/* Electrico */
object pikachu inherits Pokemon (nombre = "Pikachu", tipo = electrico,
  ataques = [golpeSeco, trueno, impactrueno, electrocanion]) {}

object shinx inherits Pokemon (nombre = "Shinx", tipo = electrico,
  ataques = [golpeSeco, rayo, chispa, trueno]) {} 

/* Planta */
object shaymin inherits Pokemon (nombre = "Shaymin", tipo = planta,
  ataques = [golpeSeco, veneno, rayoSolar, curarse]) {}

object bulbasaur inherits Pokemon (nombre = "Bulbasaur", tipo = planta,
  ataques = [golpeSeco, latigoCepa, veneno, curarse]) {}