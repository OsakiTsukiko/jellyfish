const std = @import("std");
const webui = @import("webui");
const RuntimeArchive = @import("scroll").RuntimeArchive;

var allocator: std.mem.Allocator = undefined;
var archive: RuntimeArchive = undefined;

pub fn init(pallocator: std.mem.Allocator, parchive: RuntimeArchive) void {
    allocator = pallocator;
    archive = parchive;
}

pub fn handler(p_path: []const u8) ?[]u8 {
    var idx: usize = 0;
    while (idx < p_path.len and p_path[idx] == '/') {
        idx += 1;
    }
    if (idx >= p_path.len) return null;

    const path = p_path[idx..];
    if (path.len <= 1) return null;

    if (archive.getData(allocator, path) catch { @panic("ERROR WITH PATH!!!"); }) |data| {
        std.log.info("File FOUND!! {s}", .{path});
        
        const pathz = allocator.dupeZ(u8, path) catch unreachable;
        defer allocator.free(pathz);
        const mime = webui.getMimeType(pathz);
        
        // "HTTP/1.1 200 OK\r\n"
        // "Content-Type: %s\r\n"
        // "Content-Length: %d\r\n"
        // "Cache-Control: no-cache\r\n\r\n";

        const header = 
            \\HTTP/1.1 200 OK
            \\Content-Type: {s}
            \\Content-Length: {d}
            \\Cache-Control: no-cache
            \\
            \\
        ;
        const header_filled = std.fmt.allocPrint(allocator, header, .{
            mime, data.len
        }) catch unreachable;
        defer allocator.free(header_filled);

        // var res = allocator.alloc(u8, header_filled.len + data.len) catch unreachable;
        var res = webui.malloc(header_filled.len + data.len);
        @memcpy(res[0..header_filled.len], header_filled);
        @memcpy(res[header_filled.len..], data);

        allocator.free(data);
        return res;
    } else {
        std.log.info("File not found: {s}", .{path});
        return null;
    }
}