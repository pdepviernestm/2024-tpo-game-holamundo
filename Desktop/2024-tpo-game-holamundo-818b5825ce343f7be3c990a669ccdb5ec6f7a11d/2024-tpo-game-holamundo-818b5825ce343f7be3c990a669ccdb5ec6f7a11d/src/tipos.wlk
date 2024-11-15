import pokemones.*

object agua {
  const property debilidad = [electrico]
}

object fuego {
  const property debilidad = [agua]
}

object planta {
  const property debilidad = [fuego]
}

object electrico {
  const property debilidad = [planta]
}