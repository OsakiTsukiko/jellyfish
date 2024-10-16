const std = @import("std");
const webui = @import("webui");

const compiler = @import("./zig/compiler.zig");
const save = @import("./save.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    compiler.setup(allocator);
    defer compiler.clean(allocator);

    save.setup(allocator);
    
    _ = webui.setDefaultRootFolder("ui");
    // TODO: CHANGE THIS TO AN ARCHIVE
    var win = webui.newWindow();

    _ = win.bind("runZig", compiler.runZigWEB);
    _ = win.bind("saveConfig", save.saveConfigWEB);
    _ = win.bind("loadConfig", save.loadConfigWEB);

    win.setSize(1350, 750);
    
    _ = win.showBrowser("index.html", .Firefox);
    // _ = win.showWv("index.html");

    webui.wait();
    webui.clean();
}