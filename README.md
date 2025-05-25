# Draft Beers

Este proyecto implementa en Haskell la lógica para gestionar el llenado, transferencia y servicio de cerveza entre tres barriles (A, B y C), cada uno representado como una tupla `(capacidad, cantidadActual)`. El objetivo es simular de manera eficiente cómo se puede servir una cantidad específica de cerveza utilizando los barriles disponibles, respetando siempre sus capacidades y restricciones.

## Funcionalidades principales

- ***initialBarrels:*** Normaliza el estado inicial de los barriles, asegurando que la cantidad de cerveza en cada uno no exceda su capacidad máxima.

- ***verifyBarrels / iSolution:*** Permiten verificar si es posible servir una cantidad deseada de cerveza desde alguno de los barriles, considerando el estado actual.

- ***addBeer:*** Añade cerveza a un barril, devolviendo el nuevo estado del barril y la cantidad sobrante si se excede la capacidad.

- ***transferBeer:*** Gestiona la transferencia de cerveza entre barriles, priorizando el llenado eficiente y evitando sobrepasar las capacidades.

- ***findBestSolution:*** Busca la mejor forma de servir la cantidad deseada, utilizando las funciones anteriores para modificar el estado de los barriles y optimizar el proceso.

## Estructura y uso

El código está organizado de forma modular, facilitando la extensión y modificación de las reglas de negocio. Cada función cumple un propósito específico dentro del flujo general de servir cerveza, desde la inicialización de los barriles hasta la búsqueda de la mejor estrategia para servir una cantidad determinada.

## Descripción detallada de las funciones principales

A continuación se presenta una explicación más formal y detallada de las funciones clave del proyecto:

- ***findBestSolution:*** Esta función centraliza la lógica para encontrar la mejor manera de servir una cantidad específica de cerveza. Primero verifica si el estado actual de los barriles es una solución válida usando `iSolution`. Si es así, retorna el estado actual y un cero indicando que no fue necesario añadir cerveza. Si no, evalúa si alguno de los barriles puede servir la cantidad solicitada mediante `verifyBarrels`. En caso afirmativo, utiliza `servBeer` y `whoServ` para determinar el barril más eficiente para servir. Si ninguna condición se cumple, retorna el estado original, indicando que no es posible servir la cantidad deseada.

- ***initialBarrels:*** Recibe tres barriles y devuelve su nuevo estado tras comprobar si alguno excede su capacidad. Si hay exceso, utiliza `transferBeer` para redistribuir la cerveza. Cada caso está cuidadosamente gestionado para asegurar que los barriles nunca superen su capacidad máxima.

- ***verifyBarrels:*** Verifica si al menos uno de los barriles tiene suficiente capacidad para servir la cantidad solicitada. Es útil para distinguir entre la ausencia de solución y datos incorrectos.

- ***transferBeer:*** Modela la transferencia de cerveza entre barriles, manejando distintos escenarios según el estado de llenado de cada barril. Utiliza recursividad para gestionar desbordamientos y prioriza el llenado eficiente.

- ***aOrC:*** Selecciona entre dos barriles el que tiene menos o igual espacio disponible, priorizando el primero en caso de empate. Esto es útil para decidir a cuál barril extremo transferir cerveza desde el barril central.

- ***calcQuantBeer:*** Calcula la cantidad de cerveza relevante para un barril específico, considerando el estado actual de todos los barriles y el objetivo de servicio.

- ***whoServ:*** Determina qué barril es el más adecuado para servir la cantidad solicitada, filtrando los barriles que cumplen con la capacidad requerida y seleccionando el óptimo mediante `determineBarrel`.

- ***determineBarrel:*** Selecciona el barril más conveniente para servir o transferir cerveza, comparando las cantidades necesarias para cada candidato y eligiendo el que requiera menos recursos.

- ***servBeer:*** Gestiona el proceso de servir cerveza desde un barril, actualizando el estado de todos los barriles y manejando posibles desbordamientos de manera coherente.

- ***modifyBarrelState:*** Actualiza el estado de uno de los tres barriles según el identificador proporcionado, manteniendo la consistencia del sistema.

Estas funciones, junto con el uso de utilidades como `uncurry`, permiten una gestión eficiente y segura del sistema de barriles. Para la implementación de algunas soluciones se consultó la documentación y ejemplos de la función [`uncurry`](https://haskellhero-es.grifart.cz/index.php?page=lessons&lesson=66#:~:text=La%20funci%C3%B3n%20uncurry%20funciona%20al,par%C3%A1metro%20de%20la%20funci%C3%B3n%20f%20.) en el sitio [Haskell Hero](https://haskellhero-es.grifart.cz/).
