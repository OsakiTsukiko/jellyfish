const std = @import("std");
const webui = @import("webui");

const zig_setup = @import("./zig/setup.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    zig_setup.setupCompiler(allocator);
    
    _ = webui.setDefaultRootFolder("ui");
    // TODO: CHANGE THIS TO AN ARCHIVE
    var win = webui.newWindow();

    win.setSize(1350, 750);
    
    _ = win.showBrowser("index.html", .Firefox);
    // _ = win.showWv("index.html");

    webui.wait();
    webui.clean();
}