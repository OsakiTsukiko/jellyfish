const std = @import("std");
const webui = @import("webui");

const init = @import("./init.zig");
const lang_loader = @import("./lang_loader.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    init.initialize(allocator);
    lang_loader.init(allocator);
    defer lang_loader.deinit(allocator);

    _ = webui.setDefaultRootFolder("ui");

    var win = webui.newWindow();

    _ = win.bind("loadLanguage", lang_loader.loadLanguage);
    _ = win.bind("compileAndRun", lang_loader.compileAndRun);

    win.setSize(1350, 750);
    
    _ = win.showBrowser("index.html", .Firefox);
    // _ = win.showWv("index.html");

    webui.wait();
    webui.clean();
}