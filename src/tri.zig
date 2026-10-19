const std = @import("std");
const rl = @import("raylib");
const bary = @import("bar.zig");
const Framebuffer = @import("framebuffer.zig").Framebuffer;
const Punto = bary.Punto;

//a es vertice rojo b es  verde y c es azul
pub const Triangulo = struct { a: Punto, b: Punto, c: Punto };

//convierte un peso a byte de color
fn a_byte(peso: f32) u8 {
    const cero: f32 = 0;
    const uno: f32 = 1;
    return @intFromFloat(@round(std.math.clamp(peso, cero, uno) * 255));
}

//cada coordenada baricentrica es la intensidad de un canal
fn color_interpolado(c: bary.Coordenadas) rl.Color {
    return .{ .r = a_byte(c.u), .g = a_byte(c.v), .b = a_byte(c.w), .a = 255 };
}

pub fn dibujar(fb: *Framebuffer, t: Triangulo) void {
    const pixeles = fb.obtener_pixeles();

    //bounding box del triangulo, recortada en este caso seugn la pantalla
    const min_x = @min(t.a.x, @min(t.b.x, t.c.x));
    const max_x = @max(t.a.x, @max(t.b.x, t.c.x));
    const min_y = @min(t.a.y, @min(t.b.y, t.c.y));
    const max_y = @max(t.a.y, @max(t.b.y, t.c.y));

    const cero: f32 = 0;
    const w_max: f32 = @floatFromInt(fb.ancho - 1);
    const h_max: f32 = @floatFromInt(fb.alto - 1);

    const x0: usize = @intFromFloat(std.math.clamp(@floor(min_x), cero, w_max));
    const x1: usize = @intFromFloat(std.math.clamp(@ceil(max_x), cero, w_max));
    const y0: usize = @intFromFloat(std.math.clamp(@floor(min_y), cero, h_max));
    const y1: usize = @intFromFloat(std.math.clamp(@ceil(max_y), cero, h_max));

    var y = y0;
    while (y <= y1) : (y += 1) {
        var x = x0;
        while (x <= x1) : (x += 1) {
            //centro del pixel
            const p = Punto{
                .x = @as(f32, @floatFromInt(x)) + 0.5,
                .y = @as(f32, @floatFromInt(y)) + 0.5,
            };

            const coords = bary.calcular(p, t.a, t.b, t.c) orelse return; //no se dibuja este  tri degenerado
            if (!bary.esta_dentro(coords)) continue;

            pixeles[y * fb.ancho + x] = color_interpolado(coords);
        }
    }
}