# Capítulo 0.3

# Build Básico NEXUS

La estructura generada automáticamente por `zig init` en la fase anterior incluye componentes que exceden el alcance del paso actual: módulo `nexus_engine`, tests, fuzzing y procesamiento de argumentos. Este capítulo reduce el proyecto a su mínima expresión funcional. Se elimina `src/root.zig`, se simplifica `build.zig` y se reemplaza `src/main.zig` por una única llamada de impresión.

El alcance se restringe a un único ejecutable que imprima la cadena `NEXUS Bootstrap OK` y termine con código de salida 0. No se añaden dependencias externas ni pasos de test. La operación valida que el sistema de build responde a una configuración manual mínima sin artefactos de la plantilla inicial.

## Tecnologías o herramientas usadas

- Zig ≥ 0.16

## Objetivo del capítulo

- Simplificar `build.zig` y `src/main.zig` al mínimo indispensable, eliminar `src/root.zig`, y lograr que `zig build run` imprima exactamente `NEXUS Bootstrap OK` con código de salida 0.

## Archivos modificados o creados

- `src/main.zig` (reemplazado)
- `build.zig` (simplificado)
- `src/root.zig` (eliminado)

## Código

**src/main.zig**

```zig
const std = @import("std");

pub fn main() !void {
    std.debug.print("NEXUS Bootstrap OK\n", .{});
}
```

**build.zig**

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "nexus_engine",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
```

**src/root.zig** se elimina.

## Explicación corta

- Se elimina complejidad accidental heredada de `zig init`: arena allocator, I/O con buffer, módulo `nexus_engine`, tests y fuzzing.
- Se reduce el build a un único ejecutable sin dependencias ni pasos de test.
- Se alinea la salida con el requisito exacto del roadmap: mensaje verificable y terminación limpia.

## Verificación

```bash
zig build run
```

Salida esperada:

```
NEXUS Bootstrap OK
```

Código de salida: 0.

Adicionalmente:

```bash
zig build
```

Debe producir el ejecutable sin errores.

## Resultado esperado

Build básico NEXUS funcional. Mensaje `NEXUS Bootstrap OK` impreso. Código de salida 0.
