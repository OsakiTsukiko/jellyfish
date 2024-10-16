# 🪼 GALLERY
### First look at running program in Terminal (st from suckless)
<img src="https://github.com/user-attachments/assets/32f7ae6e-060b-4f28-9583-69b185902de5" width="100%">

### Running raylib example with minimal source tweaks (execution command wrapper for lib path)
<img src="https://github.com/user-attachments/assets/02675591-3093-4f47-8f72-f442b044c723" width="100%">

### Compiler Arguments
<img src="https://github.com/user-attachments/assets/474eeeb4-55e6-4efc-89e7-2d4770f86d46" width="100%">
<img src="https://github.com/user-attachments/assets/04837034-24d8-4ded-9382-053dbefdfd36" width="100%">

### Usable.. Somewhat
I wrote a simple bit of code that renders a circle around the mouse using raylib. The editor is usable but still
needs lots of work. The thing I miss the most is autocomplete, but that is mostly out of the scope of this project.
Real programmers don't need no autocomplete.
<img src="https://github.com/user-attachments/assets/aad3c7ac-4cee-4779-8507-d0afa2ccbcf2" width="100%">
CODE:
```zig
// build with comp arguments `-lc -lraylib` and `LD_LIBRARY_PATH=/usr/local/lib` as pre run wrapper

const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() void {
    const screenWidth = 800;
    const screenHeight = 450;

    ray.InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        const mpos: ray.Vector2 = ray.GetMousePosition();
        ray.ClearBackground(ray.RAYWHITE);
        ray.DrawText("Hello, World!", 190, 200, 20, ray.LIGHTGRAY);
        ray.DrawCircle(@as(i32, @intFromFloat(mpos.x)), @as(i32, @intFromFloat(mpos.y)), 50, ray.PINK);
    }
}
```
