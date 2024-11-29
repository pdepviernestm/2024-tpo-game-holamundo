# Batalla Pokemon

## Equipo de desarrollo

- Tobias Abel Albornoz
- Brisa Calzado
- Marcos Silva
- Matias Nuñez

## Menu Inicio Batalla Pokemon

![Menu Inicio](assets\FondoInicio2.png)


## Reglas de Juego / Instrucciones

 El juego es sencillo, simula una batalla de pokemones en el cual tendremos que elegir 3 pokemones para nosotros y otros 3 para la máquina. Al iniciar el escenario de batalla simpre comenzamos nosotros con 4 ataques disponibles que pueden ser: 

- Golpe Seco: Es una ataque default para todos los pokemones que no pertenece a ningun elemento.

- Ataque elemental: Es un ataque del elemento del pokemon, con un daño normal.

- Ataque especial: Es un ataque fuerte del elemento del pokemon que inflinge mayor daño.

- Curarse: Es un ataque sin daño que se efectua al propio pokemon que lo realiza recuperando un porcentaje de vida. Este ataque es porpio de los pokemones de tipo agua y planta.

Cada pokemon posee un turno para atacar, en el caso de la máquina realiza el ataque aleatorio de su set de ataques ponderando el ataque con mas daño y en el caso realizar el poder de curación solo lo hace si tiene vida por curar.

### Tipos de elementos de pokemones:
Para no complejizar de mas el game, decidimos optar por 4 tipos de elementos para los pokemones siendo estos tipo Planta, Agua, Fuego y Eléctrico.

![Imagen elementos](Elementos.png)

### Daños a elementos:
Debemos aclarar que los daños que pueden inflingir los pokemones con sus ataques depende puramente del elemento del mismo y del rival.
A continuación veremos los daños críticos, normal y débil que se pueden tener:
![Tabla elementos](assets\tablaAtaques.png)

## Otros

- K2005 / UTN_FRBA
- Versión de wollok: 0.2.7
- Una vez terminado, no tenemos problemas en que el repositorio sea público 
