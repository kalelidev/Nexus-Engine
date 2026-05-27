# Capítulo 2

# Integración de vulkan-zig

Se integran los bindings de Vulkan para Zig (vulkan-zig) junto con Vulkan-Headers como fuente del registro `vk.xml` requerido para la generación de bindings. Este paso valida exclusivamente la fase de compilación del import; no se inicializa Vulkan ni se crea instancia, surface o renderer.

Durante la integración se detectó que vulkan-zig no opera como módulo importable directo comparable a SDL3. Requiere el archivo `vk.xml` de Vulkan-Headers para generar los bindings, lo cual condiciona la configuración del build system y la declaración de dependencias en `build.zig.zon`.

Se produjo un error de nombre de módulo exportado (`unable to find module 'vulkan'`), resuelto al identificar que el paquete vulkan-zig exporta el módulo internamente como `"vulkan-zig"`. El alias de import del ejecutable se mantiene como `"vulkan"` para preservar una API limpia en el código del engine.

## Tecnologías o herramientas usadas

- Zig ≥ 0.16
- vulkan-zig
- Vulkan-Headers (`vk.xml`)

## Objetivo del capítulo

- Integrar vulkan-zig + Vulkan-Headers para permitir que `@import("vulkan")` compile correctamente. Validación únicamente de import.

## Archivos modificados o creados

- `build.zig.zon` (modificado)
- `build.zig` (modificado)
- `src/main.zig` (modificado)

## Código

**build.zig.zon**

```zig
.{
    .name = "nexus_engine",
    .version = "0.0.0",
    .dependencies = .{
        .vulkan = .{
            .url = "git+https://github.com/Snektron/vulkan-zig.git",
            .hash = "vulkan-0.0.0-r7Ytx7N9AwD7IZt5_XNHtkJ4G9qY0pCH-cpcOsbL8wzD",
        },
.vulkan_headers = .{
            .url = "git+https://github.com/KhronosGroup/Vulkan-Headers#015e25c3c91b70eb1a754d36fb14c4ba6ad9b0b9",
            .hash = "N-V-__8AAK9XtgdbE-7U3nligMlYZfjYIvWD6lC9_zLHSNQn",
        },,
    },
    .paths = .{
        "build.zig",
        "build.zig.zon",
        "src",
    },
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

    // Vulkan bindings
    const registry = b.dependency("vulkan_headers", .{}).path("registry/vk.xml");
    const vulkan_mod = b.dependency("vulkan", .{
        .registry = registry,
    }).module("vulkan-zig");
    
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
    .{
        .name = "vulkan",
        .module = vulkan_mod,
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

**src/main.zig**

```zig
const std = @import("std");
const sdl = @import("sdl");
const vulkan = @import("vulkan");

pub fn main() !void {
    _ = sdl;
    _ = vulkan;

    std.debug.print("NEXUS Bootstrap OK\n", .{});
}
```

## Explicación corta

- vulkan-zig requiere `vk.xml` de Vulkan-Headers para generar los bindings; no es un módulo importable directo como SDL3.
- El paquete vulkan-zig exporta el módulo internamente como `"vulkan-zig"`, no `"vulkan"`. El alias de import del ejecutable se define como `"vulkan"` para mantener la API limpia.
- No se crea wrapper `src/vulkan.zig`; el import directo es suficiente para la validación de compilación de este paso.

## Verificación

```bash
rm -rf .zig-cache zig-out
zig fetch
zig build
zig build run
```

Salida esperada:

```
NEXUS Bootstrap OK
```

Compilación sin errores. Ausencia del mensaje `unable to find module`.

## Resultado esperado

Import de vulkan-zig compilable.
