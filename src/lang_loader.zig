const std = @import("std");
const fs = std.fs;
const builtin = @import("builtin");

const webui = @import("webui");

pub var compiler_path: ?[]u8 = null;
pub var current_lang: ?ProgLang = null;
var local_allocator: ?std.mem.Allocator = null;

pub const ProgLang = enum(c_int) {
    C = 0,
    CPP = 1,
    ZIG = 2,
};

pub fn init(allocator: std.mem.Allocator) void {
    local_allocator = allocator;
}
pub fn deinit(allocator: std.mem.Allocator) void {
    if (compiler_path != null) {
        allocator.free(compiler_path.?);
    }
}

pub fn loadLanguage(event: webui.Event) void {
    const allocator = local_allocator.?;
    const language: ProgLang = @as(ProgLang, @enumFromInt(event.getInt()));
    switch (language) {
        .C => {
            loadC(allocator);
        },
        .CPP => {

        },
        .ZIG => {
            loadZig(allocator);
        },
    }
}

pub fn loadC(allocator: std.mem.Allocator) void {
    const exe_dir_path = fs.selfExeDirPathAlloc(allocator) catch unreachable;
    defer allocator.free(exe_dir_path);
    const exe_dir = fs.openDirAbsolute(
        exe_dir_path, .{}
    ) catch unreachable; // TODO: HANDLE ERROR MAYBE?

    const compilers = exe_dir.openDir("compilers", .{}) catch unreachable;

    compilers.makeDir("gcc") catch |err| {
        if (err == error.PathAlreadyExists) {
            std.debug.print("`gcc` folder already exists\n", .{});
            // pray that it's not a file
            const gcc = compilers.openDir(
                "gcc", .{}
            ) catch unreachable;
            
            switch (builtin.os.tag) {
                .macos, .freebsd, .netbsd, .dragonfly, .openbsd => {
                    // TODO: SUPPORT MACOS
                    unreachable;
                },
                .linux => {
                    const distr = gcc.openDir(
                        "linux", .{}
                    ) catch unreachable;

                    const comp = distr.openFile(
                        "gcc", .{}
                    ) catch unreachable;
                    _ = comp;
                    std.debug.print("COMPILER EXISTS\n", .{});

                    if (compiler_path != null) {
                        allocator.free(compiler_path.?);
                    }
                    
                    current_lang = .C;
                    compiler_path = distr.realpathAlloc(
                        allocator, "gcc"
                    ) catch unreachable;
                    return;
                },
                .windows => {
                    // TODO: SUPPORT WINDOWS
                    unreachable;
                },

                else => @compileError("Unsupported OS"),
            }
        } else {
            std.debug.panic("Error creating `gcc` folder!", .{});
            unreachable;
        }
    };


}

pub fn loadZig(allocator: std.mem.Allocator) void {
    const exe_dir_path = fs.selfExeDirPathAlloc(allocator) catch unreachable;
    defer allocator.free(exe_dir_path);
    const exe_dir = fs.openDirAbsolute(
        exe_dir_path, .{}
    ) catch unreachable; // TODO: HANDLE ERROR MAYBE?

    const compilers = exe_dir.openDir("compilers", .{}) catch unreachable;

    compilers.makeDir("zig") catch |err| {
        if (err == error.PathAlreadyExists) {
            std.debug.print("`zig` folder already exists\n", .{});
            // pray that it's not a file
            const zig = compilers.openDir(
                "zig", .{}
            ) catch unreachable;
            
            switch (builtin.os.tag) {
                .macos, .freebsd, .netbsd, .dragonfly, .openbsd => {
                    // TODO: SUPPORT MACOS
                    unreachable;
                },
                .linux => {
                    const distr = zig.openDir(
                        "linux", .{}
                    ) catch unreachable;

                    const comp = distr.openFile(
                        "zig", .{}
                    ) catch unreachable;
                    _ = comp;
                    std.debug.print("COMPILER EXISTS\n", .{});

                    if (compiler_path != null) {
                        allocator.free(compiler_path.?);
                    }
                    
                    current_lang = .ZIG;
                    compiler_path = distr.realpathAlloc(
                        allocator, "zig"
                    ) catch unreachable;
                    return;
                },
                .windows => {
                    // TODO: SUPPORT WINDOWS
                    unreachable;
                },

                else => @compileError("Unsupported OS"),
            }
        } else {
            std.debug.panic("Error creating `zig` folder!", .{});
            unreachable;
        }
    };
}

pub fn compileAndRun(event: webui.Event) void {
    compile(event);
}

pub fn compile(event: webui.Event) void {
    switch (current_lang.?) {
        .C => {

        },
        .CPP => {

        },
        .ZIG => {
            const filename = "source.zig";
            const dir_name = "temp_build";

            std.debug.print("{s}\n{s}\n", .{compiler_path.?, event.getString()});
            
            fs.cwd().makeDir(
                "temp_build"
            ) catch {

            };

            const dir = fs.cwd().openDir(
                dir_name, 
                .{}
            ) catch unreachable;

            const file = dir.createFile(
                filename,
                .{ .read = true }
            ) catch unreachable;

            file.writeAll(event.getString()) catch unreachable; // TODO: HANDLE THIS
            file.close();

            const path = dir.realpathAlloc(local_allocator.?, filename) catch unreachable;
            defer local_allocator.?.free(path);
            std.debug.print("{s}\n", .{path});

            compileZig(path);
            cleanUP(dir_name);
        },
    }
}

pub fn cleanUP(dir: []const u8) void {
    fs.cwd().deleteTree(dir) catch unreachable;
}

pub fn compileZig(path: []const u8) void {
    const run = std.process.Child.run(.{
        .allocator = local_allocator.?,
        .argv = &[_][]const u8{
            compiler_path.?,
            "build-exe",
            path,
        },
    }) catch undefined;
    std.debug.print("{s}\n", .{run.stdout});
}