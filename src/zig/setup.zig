const std = @import("std");
const fs = std.fs;
const builtin = @import("builtin");

pub fn setupCompiler(allocator: std.mem.Allocator) void {
    const exe_dir_path = fs.selfExeDirPathAlloc(allocator) catch unreachable; // should be fine?
    defer allocator.free(exe_dir_path);

    const exe_dir = fs.openDirAbsolute(
        exe_dir_path, .{.iterate = true}
    ) catch unreachable; // TODO: HANDLE ERRORS (QUIT)

    switch (builtin.os.tag) {
        .macos, .freebsd, .netbsd, .dragonfly, .openbsd => {
            // TODO: SUPPORT MACOS
            unreachable;
        },
        .linux => {
            const compiler_dir = exe_dir.openDir("zig/linux", .{}) catch {
                // INSTALATION DOES NOT HAVE COMPILER
                // TODO: HANDLE THIS
                unreachable;
            };
            _ = compiler_dir;
        },
        .windows => {
            // TODO: SUPPORT WINDOWS
            unreachable;
        },  
        else => @compileError("Unsupported OS"),
    }
}