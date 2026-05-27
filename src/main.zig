const std = @import("std");
const sdl = @import("sdl");
const vulkan = @import("vulkan");

pub fn main() !void {
    _ = sdl;
    _ = vulkan;

    std.debug.print("NEXUS Bootstrap OK\n", .{});
}
