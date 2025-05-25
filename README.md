# Proyecto-1-LdP

Este proyecto implementa en Haskell la lógica para gestionar el llenado, transferencia y servicio de cerveza entre tres barriles (A, B y C), cada uno representado como una tupla `(capacidad, cantidadActual)`. El objetivo es simular de manera eficiente cómo se puede servir una cantidad específica de cerveza utilizando los barriles disponibles, respetando siempre sus capacidades y restricciones.

## Funcionalidades principales

- **initialBarrels:** Normaliza el estado inicial de los barriles, asegurando que la cantidad de cerveza en cada uno no exceda su capacidad máxima.

- **verifyBarrels / iSolution:** Permiten verificar si es posible servir una cantidad deseada de cerveza desde alguno de los barriles, considerando el estado actual.

- **addBeer:** Añade cerveza a un barril, devolviendo el nuevo estado del barril y la cantidad sobrante si se excede la capacidad.

- **transferBeer:** Gestiona la transferencia de cerveza entre barriles, priorizando el llenado eficiente y evitando sobrepasar las capacidades.

- **findBestSolution:** Busca la mejor forma de servir la cantidad deseada, utilizando las funciones anteriores para modificar el estado de los barriles y optimizar el proceso.

## Estructura y uso

El código está organizado de forma modular, facilitando la extensión y modificación de las reglas de negocio. Cada función cumple un propósito específico dentro del flujo general de servir cerveza, desde la inicialización de los barriles hasta la búsqueda de la mejor estrategia para servir una cantidad determinada.