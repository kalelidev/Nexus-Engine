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
