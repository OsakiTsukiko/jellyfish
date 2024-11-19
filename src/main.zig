const std = @import("std");
const webui = @import("webui");

const compiler = @import("./zig/compiler.zig");
const save = @import("./save.zig");
const file_handler = @import("./handler.zig");
const RuntimeArchive = @import("scroll").RuntimeArchive;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    compiler.setup(allocator);
    defer compiler.clean(allocator);

    const archive_file = try compiler.exe_directory.openFile("ui.jellyfish", .{});
    defer archive_file.close();
    const archive = try RuntimeArchive.new(archive_file);
    file_handler.init(allocator, archive);

    save.setup(allocator);
    
    // _ = webui.setDefaultRootFolder("ui");
    // TODO: CHANGE THIS TO AN ARCHIVE
    var win = webui.newWindow();
    win.setFileHandler(file_handler.handler);

    _ = win.bind("runZig", compiler.runZigWEB);
    _ = win.bind("saveConfig", save.saveConfigWEB);
    _ = win.bind("loadConfig", save.loadConfigWEB);

    win.setSize(1350, 750);
    
    _ = win.showBrowser("index.html", .Firefox);
    // _ = win.showWv("index.html");

    webui.wait();
    webui.clean();
}