const std = @import("std");

pub const Punto = struct { x: f32, y: f32 };

//siempre deben de sumar 1
pub const Coordenadas = struct { u: f32, v: f32, w: f32 };


//el signo depende de si los vertices van en sentido horario o antihorario
pub fn area_doble(a: Punto, b: Punto, c: Punto) f32 {
    return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
}

//coordenadas baricentricas de p respecto al triangulo a, b, c

pub fn calcular(p: Punto, a: Punto, b: Punto, c: Punto) ?Coordenadas {
    const total = area_doble(a, b, c);
    if (@abs(total) < 1e-6) return null;//devuelve null si el triangulo tiene area = 0

    return .{
        .u = area_doble(p, b, c) / total, 
        .v = area_doble(a, p, c) / total, 
        .w = area_doble(a, b, p) / total, 
    };
}

//p esta dentro si no hay coordenada es negativa
pub fn esta_dentro(coords: Coordenadas) bool {
    return coords.u >= 0 and coords.v >= 0 and coords.w >= 0;
}

test "en un vertice, su peso es 1 y los demas 0" {
    const a = Punto{ .x = 0, .y = 0 };
    const b = Punto{ .x = 10, .y = 0 };
    const c = Punto{ .x = 0, .y = 10 };
    const r = calcular(a, a, b, c).?;
    try std.testing.expectApproxEqAbs(@as(f32, 1), r.u, 1e-5);
    try std.testing.expectApproxEqAbs(@as(f32, 0), r.v, 1e-5);
    try std.testing.expectApproxEqAbs(@as(f32, 0), r.w, 1e-5);
}

test "funciona con cualquier orientacion y suma 1" {
    const a = Punto{ .x = 0, .y = 0 };
    const b = Punto{ .x = 0, .y = 10 }; //orden horario
    const c = Punto{ .x = 10, .y = 0 };
    const r = calcular(.{ .x = 2, .y = 3 }, a, b, c).?;
    try std.testing.expect(esta_dentro(r));
    try std.testing.expectApproxEqAbs(@as(f32, 1), r.u + r.v + r.w, 1e-5);
}

test "un punto fuera tiene alguna coordenada negativa" {
    const r = calcular(.{ .x = 20, .y = 20 }, .{ .x = 0, .y = 0 }, .{ .x = 10, .y = 0 }, .{ .x = 0, .y = 10 }).?;
    try std.testing.expect(!esta_dentro(r));
}

test "triangulo degenerado devuelve null" {
    const p = Punto{ .x = 1, .y = 1 };
    try std.testing.expect(calcular(p, .{ .x = 0, .y = 0 }, .{ .x = 5, .y = 5 }, .{ .x = 10, .y = 10 }) == null);
}