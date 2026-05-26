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
