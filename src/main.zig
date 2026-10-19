const rl = @import("raylib");
const Framebuffer = @import("framebuffer.zig").Framebuffer;
const tri = @import("tri.zig");

const ancho = 800;
const alto = 450;

//3 triangulos distintos donde a es rojo b es verde y c azul
const triangulos = [_]tri.Triangulo{
    //tipo isosceles
    .{ .a = .{ .x = 40, .y = 430 }, .b = .{ .x = 400, .y = 20 }, .c = .{ .x = 760, .y = 430 } },
    //escaleno
    .{ .a = .{ .x = 200, .y = 430 }, .b = .{ .x = 400, .y = 20 }, .c = .{ .x = 760, .y = 430 } },
    // obtuso y con otra orientacion de tipo vertices
    .{ .a = .{ .x = 20, .y = 20 }, .b = .{ .x = 400, .y = 430 }, .c = .{ .x = 150, .y = 20 } },
};

const rutas = [_][:0]const u8{
    "imagenes/triangulo1.png",
    "imagenes/triangulo2.png",
    "imagenes/triangulo3.png",
};

pub fn main() !void {
    rl.initWindow(ancho, alto, "Triangulo baricentrico");
    rl.setTraceLogLevel(.warning);
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var framebuffer = Framebuffer.init(ancho, alto);
    defer framebuffer.liberar();

    var actual: usize = 0;
    var cambio = true; //solo se vuelve a renderizar cuando el triangulo cambia

    while (!rl.windowShouldClose()) {
        if (rl.isKeyPressed(.one)) {
            actual = 0;
            cambio = true;
        }
        if (rl.isKeyPressed(.two)) {
            actual = 1;
            cambio = true;
        }
        if (rl.isKeyPressed(.three)) {
            actual = 2;
            cambio = true;
        }

        if (rl.isKeyPressed(.g)) framebuffer.guardar(rutas[actual]);

        if (cambio) {
            framebuffer.limpiar();
            tri.dibujar(&framebuffer, triangulos[actual]);
            cambio = false;
        }

        try framebuffer.mostrar();
    }
}