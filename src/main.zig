const std = @import("std");
const sdl = @import("sdl").c;

const sdl_log = std.log.scoped(.sdl);

pub fn main() !void {
    _ = sdl;

    std.debug.print("NEXUS Bootstrap OK\n", .{});
}
