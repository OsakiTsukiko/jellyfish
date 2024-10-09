const std = @import("std");
const webui = @import("webui");

const compiler = @import("./zig/compiler.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    compiler.setup(allocator);
    defer compiler.clean(allocator);
    
    _ = webui.setDefaultRootFolder("ui");
    // TODO: CHANGE THIS TO AN ARCHIVE
    var win = webui.newWindow();

    _ = win.bind("runZig", compiler.runZigWEB);

    win.setSize(1350, 750);
    
    _ = win.showBrowser("index.html", .Firefox);
    // _ = win.showWv("index.html");

    webui.wait();
    webui.clean();
}