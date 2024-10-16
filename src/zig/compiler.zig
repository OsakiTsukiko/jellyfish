const std = @import("std");
const fs = std.fs;
const process = std.process;
const builtin = @import("builtin");

const webui = @import("webui");

var exe_directory: ?fs.Dir = null;

const ZIG_PATH_LINUX = "zig/linux";
const ZIG_PATH_WINDOWS = "zig/windows";
const ZIG_PATH_MACOS = "zig/macos";

const BUILD_DIRECTORY= "temp_build";
const BUILD_FILE = "main.zig";

var local_allocator: ?std.mem.Allocator = null;
var compiler_dir: ?fs.Dir = null;
var compiler_path: ?[]const u8 = null;

pub fn setup(allocator: std.mem.Allocator) void {
    local_allocator = allocator;

    const exe_dir_path = fs.selfExeDirPathAlloc(allocator) catch unreachable; // should be fine?
    defer allocator.free(exe_dir_path);

    const exe_dir = fs.openDirAbsolute(
        exe_dir_path, .{.iterate = true}
    ) catch unreachable; // TODO: HANDLE ERRORS (QUIT)
    exe_directory = exe_dir;

    switch (builtin.os.tag) {
        .macos, .freebsd, .netbsd, .dragonfly, .openbsd => {
            // TODO: SUPPORT MACOS
            unreachable;
        },
        .linux => {
            const comp_dir = exe_dir.openDir(ZIG_PATH_LINUX, .{}) catch {
                // INSTALATION DOES NOT HAVE COMPILER
                // TODO: HANDLE THIS
                unreachable;
            };
            compiler_dir = comp_dir;
            const comp_path = compiler_dir.?.realpathAlloc(allocator, "zig") catch unreachable;
            compiler_path = comp_path;
        },
        .windows => {
            // TODO: SUPPORT WINDOWS
            unreachable;
        },  
        else => @compileError("Unsupported OS"),
    }
}

pub fn clean(allocator: std.mem.Allocator) void {
    if (compiler_path) |comp_path| allocator.free(comp_path);
} 

// return must be freed
fn loadZig(allocator: std.mem.Allocator, code: []const u8) []u8 { // TODO: ADD ERROR RETURN
    exe_directory.?.makeDir(BUILD_DIRECTORY) catch |err| switch (err) {
        error.PathAlreadyExists => {
            std.debug.print("PATH ALREADY EXISTS\n", .{});
        },
        else => {
            unreachable;
            // TODO: PANIC OR SUM
        },
    };

    const build_dir = exe_directory.?.openDir(BUILD_DIRECTORY, .{}) catch unreachable; // TODO: maybe handle?
    const build_file = build_dir.createFile(BUILD_FILE, .{ .read = true }) catch |err| switch (err) {
        error.PathAlreadyExists => pae_f: {
            const file = build_dir.openFile(BUILD_FILE, .{}) catch {
                unreachable;
                // TODO: HANDLE ERROR
            };
            break :pae_f file;
        },
        else => {
            unreachable;
            // TODO: HANDLE ERROR
        },
    };

    _ = build_file.writeAll(code) catch unreachable; // TODO: maybe handle error?
    build_file.close();

    const file_path = build_dir.realpathAlloc(
        allocator, 
        BUILD_FILE
    ) catch unreachable; // TODO: HANDLE?

    return file_path;
}

fn runZig(allocator: std.mem.Allocator, comp_path: []const u8, file_path: []const u8, comp_arg: []const u8, pre_run_wrapper: []const u8) void {
    switch (builtin.os.tag) {
        .macos, .freebsd, .netbsd, .dragonfly, .openbsd => {
            // TODO: SUPPORT MACOS
            unreachable;
        },
        .linux => {
            // use gnome terminal
            // gnome-terminal -- bash -c "command; read -p 'Press Enter to close...'"
            // update: gnome-terminal exits before actually executing anything, thus
            // we can not detect when to remove the files thus using suckless st for
            // now. (could also bundle st as it is under mit)

            // const command = std.fmt.bufPrintZ(buf: []u8, comptime fmt: []const u8, args: anytype)
            const command = std.fmt.allocPrintZ(
                allocator, 
                "({s} {s} run {s} {s};read -p 'Press [ENTER] to close...')",
                .{pre_run_wrapper, comp_path, file_path, comp_arg}
            ) catch unreachable;
            defer allocator.free(command);

            var proc = process.Child.init(
                &[_][]const u8{
                    "st",
                    "-e",
                    "bash",
                    "-c",
                    command,
                },
                allocator,
            );

            proc.spawn() catch unreachable; // TODO: HANDLE ERR?
            _ = proc.wait() catch unreachable;
            std.debug.print("TERMINAL EXITED (PROBABLY)\n", .{});
        },
        .windows => {
            // TODO: SUPPORT WINDOWS
            unreachable;
        },  
        else => @compileError("Unsupported OS"),
    }
}

fn cleanZig() void {
    exe_directory.?.deleteTree(BUILD_DIRECTORY) catch {
        // TODO: HANDLE PATH ALREADY EXISTS + OTHER
        unreachable;
    };
}

pub fn runZigWEB(event: webui.Event) void {
    const allocator = local_allocator.?;
    const code = event.getStringAt(0);
    const comp_arg = event.getStringAt(1);
    const pre_run_wrapper = event.getStringAt(2);

    const file_path = loadZig(allocator, code);
    defer allocator.free(file_path);
    runZig(allocator, compiler_path.?, file_path, comp_arg, pre_run_wrapper);
    cleanZig();
}