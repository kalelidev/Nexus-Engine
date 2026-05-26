# Capítulo 1

# Integración de SDL3

Este capítulo integra SDL3 como dependencia del proyecto NEXUS Engine y valida que el binding mínimo compile sin errores. Se crea un módulo Zig que expone los headers de SDL3 mediante `@cImport`, configurando el sistema de build para vincular la biblioteca al ejecutable principal. El alcance se limita exclusivamente a la verificación de compilación; no se inicializa SDL3 ni se ejecuta código de su API durante el runtime. Se modifica `main.zig` para importar el módulo y descartarlo explícitamente, forzando al compilador a procesar el binding completo.

## Tecnologías o herramientas usadas

- Zig ≥ 0.16
- SDL3
- `@cImport` / `@cInclude`

## Objetivo del capítulo

- Agregar SDL3 como dependencia y validar que `@import("sdl")` compile correctamente, sin inicializar ni usar la librería.

## Archivos modificados o creados

- `src/sdl.zig` (creado)
- `src/main.zig` (modificado)
- `build.zig` (modificado)

## Código

**src/sdl.zig**

```zig
pub const c = @cImport({
    @cDefine("SDL_MAIN_HANDLED", "1");

    @cInclude("SDL3/SDL.h");
});
```

**src/main.zig**

```zig
const std = @import("std");
const sdl = @import("sdl").c;

const sdl_log = std.log.scoped(.sdl);

pub fn main() !void {
    _ = sdl;

    std.debug.print("NEXUS Bootstrap OK\n", .{});
}
```

**build.zig**

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Dependencia SDL3
    const sdl_dep = b.dependency("sdl", .{
        .target = target,
        .optimize = optimize,
    });

    const sdl_lib = sdl_dep.artifact("SDL3");

    // Wrapper SDL (src/sdl.zig)
    const sdl_module = b.createModule(.{
        .root_source_file = b.path("src/sdl.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Permite que @cImport encuentre SDL3/SDL.h
    // y hereda información de link/include.
    sdl_module.linkLibrary(sdl_lib);

    // Ejecutable principal
    const exe = b.addExecutable(.{
        .name = "nexus_engine",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{
                    .name = "sdl",
                    .module = sdl_module,
                },
            },
        }),
    });

    // Link SDL al ejecutable
    exe.root_module.linkLibrary(sdl_lib);

    // Instalar binario
    b.installArtifact(exe);

    // zig build run
    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run NEXUS Engine");
    run_step.dependOn(&run_cmd.step);
}
```

## Explicación corta

- `@cImport` directo de `SDL3/SDL.h` con `SDL_MAIN_HANDLED` para evitar que SDL3 redefina `main`.
- Módulo `sdl` creado en `build.zig` mediante `b.createModule` y vinculado a la biblioteca SDL3 vía `linkLibrary`.
- El ejecutable principal importa el módulo `sdl` y lo descarta con `_ = sdl` para forzar la compilación del binding sin generar código de ejecución.

## Verificación

```bash
zig build run
```

Debe compilar sin errores y mostrar:

```
NEXUS Bootstrap OK
```

Código de salida: 0.

## Resultado esperado

Import de SDL3 compilable.
