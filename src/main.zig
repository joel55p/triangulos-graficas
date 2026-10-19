const rl = @import("raylib");

const ancho = 800;
const alto = 450;

pub fn main() !void {
    rl.initWindow(ancho, alto, "Triangulito");
    rl.setTraceLogLevel(.warning);
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(.black);
    }
}