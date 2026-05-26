# Capítulo 0.1

# Instalación de Zig

Este capítulo valida la disponibilidad del toolchain base. NEXUS Engine requiere Zig 0.16 o superior, versión no presente en los repositorios estables de Void Linux al momento de esta fase. La solución ejecutada consiste en aplicar los cambios del PR #59955 al template del paquete `zig` en void-packages, reconstruir mediante xbps-src e instalar el binario resultante. Este paso no construye código del engine; establece el fundamento sobre el que se ejecutarán las fases siguientes.

El alcance se limita a documentar el requisito, referenciar el PR exacto y crear el archivo README.md raíz con la información mínima de instalación. No se genera `build.zig` ni se compila el proyecto; esas tareas corresponden a fases posteriores del roadmap.

## Tecnologías o herramientas usadas

- Zig (objetivo: ≥ 0.16)
- Void Linux
- xbps-src / xbps (gestión de paquetes)

## Objetivo del capítulo

- Disponer de Zig 0.16 o superior en Void Linux aplicando la actualización del template del PR #59955, verificable mediante `zig version`.

## Archivos modificados o creados

- `README.md` (creado)

## Código

```markdown
# NEXUS Engine

## Requisitos de sistema

- **Zig** ≥ 0.16 (última estable)
- **Void Linux** (actualizado a 2026-05-25 o posterior)

## Instalación de Zig en Void Linux

El repositorio oficial de Void contiene actualmente Zig 0.13.0.  
Para obtener Zig 0.16+ es necesario aplicar los cambios del siguiente PR (aún en draft):

[https://github.com/void-linux/void-packages/pull/59955 ](https://github.com/void-linux/void-packages/pull/59955 )

El usuario debe seguir las instrucciones del PR para actualizar el template `zig` y reconstruir el paquete xbps.  
Este documento asume que dichos pasos ya fueron completados correctamente.

## Verificación

Ejecutar en terminal:

```bash
zig version
```

**Salida esperada:** `0.16.0` o superior (ej: `0.16.0`, `0.17.0`, etc.)

Si la versión es inferior, revisar que el template se haya actualizado y el paquete reinstalado.
```

## Explicación corta

- Registro del requisito de toolchain en el documento raíz del proyecto.
- Referencia exacta al PR #59955 para trazabilidad de la fuente del paquete.
- Base documental mínima antes de introducir lógica de compilación.

## Verificación

```bash
zig version
```

El comando debe imprimir una cadena de versión mayor o igual a `0.16.0`. Cualquier salida inferior (por ejemplo, `0.13.0`) indica que la actualización del template no se aplicó correctamente.

## Resultado esperado

Toolchain Zig validada en versión 0.16+.
