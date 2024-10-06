const webui = @import("webui");

pub fn main() !void {
    _ = webui.setDefaultRootFolder("ui");

    var win = webui.newWindow();
    win.setSize(1350, 750);
    
    _ = win.showBrowser("index.html", .Firefox);
    // _ = win.showWv("index.html");

    webui.wait();
    webui.clean();
}