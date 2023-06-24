// Draw particles
for (var i = 0; i < ds_list_size(parts); i ++) {
	var prt = parts[|i]

	draw_sprite_ext(prt.spr, 0,
		x + prt.x, y + prt.y, 1, 1,
		prt.rot, c_white, prt.alpha)
}