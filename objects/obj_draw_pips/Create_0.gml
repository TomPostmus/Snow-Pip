// Draw trunk of each pip
function draw_trunks() {
	for (var i = 0; i < instance_number(obj_pip); i++) {
		var pip = instance_find(obj_pip, i)
		
		draw_sprite_ext(spr_pip_trunk, pip.walk_index,
			pip.collision.x + lengthdir_x(2, pip.rotation),
			pip.collision.y + lengthdir_y(2, pip.rotation),
			1, 1, pip.rotation, c_white, 1)
	}
}

// Draw head of each pip
function draw_heads() {
	for (var i = 0; i < instance_number(obj_pip); i++) {
		var pip = instance_find(obj_pip, i)
		
		draw_sprite_ext(spr_pip_head, 0,
			pip.collision.x + lengthdir_x(8, pip.rotation),
			pip.collision.y + lengthdir_y(8, pip.rotation),
			1, 1, pip.rotation, c_white, 1)
	}
}