// Draw trunk of each pip and update hmask
function draw_trunks() {
	for (var i = 0; i < instance_number(obj_pip); i++) {
		var pip = instance_find(obj_pip, i)
		
		var trunk_x = pip.collision.x + lengthdir_x(2, pip.rotation)
		var trunk_y = pip.collision.y + lengthdir_y(2, pip.rotation)
		
		draw_sprite_ext(spr_pip_trunk, pip.walk_index, // draw
			trunk_x, trunk_y, 1, 1, pip.rotation, c_white, 1)
			
		with(pip.hmask_trunk) { // update hitmask
			x = trunk_x; y = trunk_y
			image_angle = pip.rotation
		}
	}
}

// Draw head of each pip and update hmask
function draw_heads() {
	for (var i = 0; i < instance_number(obj_pip); i++) {
		var pip = instance_find(obj_pip, i)
		
		var head_x = pip.collision.x + lengthdir_x(8, pip.rotation)
		var head_y = pip.collision.y + lengthdir_y(8, pip.rotation)
		
		draw_sprite_ext(spr_pip_head, 0,
			head_x, head_y, 1, 1, pip.rotation, c_white, 1)
			
		with(pip.hmask_head) { // update hitmask
			x = head_x; y = head_y
			image_angle = pip.rotation
		}
	}
}