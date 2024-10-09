const std = @import("std");
const fs = std.fs;

pub fn initialize(allocator: std.mem.Allocator) void {
    const exe_dir_path = fs.selfExeDirPathAlloc(allocator) catch unreachable;
    defer allocator.free(exe_dir_path);
    const exe_dir = fs.openDirAbsolute(
        exe_dir_path, .{.iterate = true}
    ) catch unreachable; // TODO: HANDLE ERROR MAYBE?

    exe_dir.makeDir("compilers") catch |err| {
        if (err == error.PathAlreadyExists) {
            std.debug.print("`compilers` folder already exists\n", .{});
        } else {
            std.debug.panic("Error creating `compilers` folder!", .{});
            unreachable;
        }
    };
}