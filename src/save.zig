const std = @import("std");
const fs = std.fs;

const webui = @import("webui");

var local_allocator: std.mem.Allocator = undefined;

pub fn setup(allocator: std.mem.Allocator) void {
    local_allocator = allocator;
}

pub fn saveData(allocator: std.mem.Allocator, filename: []const u8, data: []const u8) void {
    const exe_dir_path = fs.selfExeDirPathAlloc(allocator) catch unreachable; // should be fine?
    defer allocator.free(exe_dir_path);

    const exe_dir = fs.openDirAbsolute(
        exe_dir_path, .{.iterate = true}
    ) catch unreachable; // TODO: HANDLE ERRORS (QUIT)
    
    std.debug.print("FILE:: {s}\n", .{filename});

    const file = exe_dir.createFile(
        filename,
        .{ .read = true },
    ) catch unreachable;
    defer file.close();

    _ = file.writeAll(data) catch unreachable;
}

// return must be freed
pub fn loadData(allocator: std.mem.Allocator, filename: []const u8) ?[]u8 {
    const exe_dir_path = fs.selfExeDirPathAlloc(allocator) catch unreachable; // should be fine?
    defer allocator.free(exe_dir_path);

    const exe_dir = fs.openDirAbsolute(
        exe_dir_path, .{.iterate = true}
    ) catch unreachable; // TODO: HANDLE ERRORS (QUIT)
    
    const file = exe_dir.openFile(
        filename,
        .{ },
    ) catch {
        return null;
    };
    defer file.close();


    const bytes_read = file.readToEndAlloc(allocator, 15360) catch unreachable;
    return bytes_read;
}

pub fn loadConfigWEB(e: webui.Event) void {
    const allocator = local_allocator;
    const filename = e.getStringAt(0);
    const data = loadData(allocator, filename);
    if (data) |d| {
        defer allocator.free(d);
        const td: [:0]u8 = std.mem.Allocator.dupeZ(allocator, u8, d) catch unreachable;
        defer allocator.free(td);
        e.returnString(td);
        return;
    } else {
        e.returnString("");
        return;
    }
}

pub fn saveConfigWEB(e: webui.Event) void {
    const allocator = local_allocator;
    const filename = e.getStringAt(0);
    const data = e.getStringAt(1);

    saveData(allocator, filename, data);
}