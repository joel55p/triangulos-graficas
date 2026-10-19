const rl = @import("raylib");

//buffer de pixeles, imagen en memoria donde se dibuja cada pixel
pub const Framebuffer = struct {
    ancho: usize,
    alto: usize,
    imagen: rl.Image,
    textura_gpu: ?rl.Texture = null,

    pub fn init(w: usize, h: usize) Framebuffer { //se crea imagen negra de w x h
        return .{
            .ancho = w,
            .alto = h,
            .imagen = rl.genImageColor(@intCast(w), @intCast(h), .black),
        };
    }

    //puntero directo al array de colores
    pub fn obtener_pixeles(self: *Framebuffer) [*]rl.Color {
        return @ptrCast(@alignCast(self.imagen.data)); //rl.Image.data es puntero a void, se necesita puntero a Color
    }

    pub fn limpiar(self: *Framebuffer) void { //pone todo en black
        self.imagen.clearBackground(.black);
    }

    //guarda el framebuffer como png
    pub fn guardar(self: *Framebuffer, ruta: [:0]const u8) void {
        _ = rl.exportImage(self.imagen, ruta);
    }

    pub fn mostrar(self: *Framebuffer) !void { //sube la imagen al GPU como textura y la dibuja
        rl.beginDrawing();
        defer rl.endDrawing();

        if (self.textura_gpu) |t| rl.unloadTexture(t);

        const tex = try rl.loadTextureFromImage(self.imagen);
        rl.drawTexture(tex, 0, 0, .white);
        self.textura_gpu = tex;
    }

    pub fn liberar(self: *Framebuffer) void {
        if (self.textura_gpu) |t| rl.unloadTexture(t);
        rl.unloadImage(self.imagen);
    }
};