# Triangulo baricentrico

Triangulo usando coordenadas baricentricas.
con colores RGB

## Funciona:yes

- Para cada pixel de la bounding box se calculan (u, v, w) con el metodo del area
- Si u, v y w son mayores  o iguales que  0 el pixel esta dentro de triangulo
- El area se calcula con signo para angulos y orientacion

## intrucciones
- 1 / 2 / 3: cambiar entre los 3 triangulos
- G: guardar el triangulo actual en `imagenes/`

## Build

```bash
zig build run
zig test src/baricentricas.zig
```