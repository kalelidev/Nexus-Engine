 # Capítulo 0.2

# Bootstrap del Proyecto Zig

Este capítulo valida que el toolchain Zig pueda generar y compilar un proyecto ejecutable desde cero. Se crea el directorio raíz del engine y se ejecuta `zig init` para generar los archivos base de un proyecto Zig moderno: `build.zig`, `build.zig.zon` y `src/main.zig`. El alcance se limita a obtener un binario funcional sin dependencias externas; no se integran aún SDL3 ni Vulkan.

El proyecto recibe el nombre `nexus-engine`. La salida esperada es un ejecutable que imprime el mensaje por defecto de `zig init`, lo cual confirma que el sistema de build, el compilador y la estructura de directorios operan correctamente.

## Tecnologías o herramientas usadas

- Zig ≥ 0.16
- `zig init`

## Objetivo del capítulo

- Generar la estructura mínima de un proyecto Zig funcional (`build.zig`, `build.zig.zon`, `src/main.zig`) que compile y produzca un ejecutable.

## Archivos creados o modificados

- `nexus-engine/build.zig` (creado por `zig init`)
- `nexus-engine/build.zig.zon` (creado por `zig init`)
- `nexus-engine/src/main.zig` (creado por `zig init`)
- `nexus-engine/src/root.zig` (creado por `zig init`)
- `nexus-engine/.gitignore` (opcional)

## Código

Comandos ejecutados:

```bash
mkdir nexus-engine
cd nexus-engine
zig init
```

Contenido opcional de `.gitignore`:

```
zig-out/
zig-cache/
```

## Explicación corta

- `zig init` genera la plantilla estándar de proyecto Zig, validando toolchain y sistema de build.
- El ejecutable resultante confirma que `build.zig`, target options y optimize options funcionan sin configuración adicional.
- Punto de partida documentado antes de introducir dependencias externas.

## Verificación

```bash
zig build
```

Debe compilar sin errores y terminar con código de salida 0.

```bash
./zig-out/bin/nexus_engine
```

Salida esperada:

```
All your codebase are belong to us.
info: arg: ./zig-out/bin/nexus_engine
Run `zig build test` to run the tests.
```

Alternativa:

```bash
zig build run
```

## Resultado esperado

Proyecto Zig bootstrap funcional. Binario ejecutable generado.
