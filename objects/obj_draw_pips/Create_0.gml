// Draw trunk of each pip and update hmask
function draw_trunks() {
	for (var i = 0; i < instance_number(obj_pip); i++) {
		var pip = instance_find(obj_pip, i)
		
		var trunk_x = pip.col_trunk.x
		var trunk_y = pip.col_trunk.y
		var trunk_rot = -pip.col_trunk.phy_rotation
		
		draw_sprite_ext(spr_pip_trunk, pip.walk_index, // draw
			trunk_x, trunk_y, 1, 1, trunk_rot, c_white, 1)
			
		//with(pip.hmask_trunk) { // update hitmask
		//	x = trunk_x; y = trunk_y
		//	image_angle = pip.rotation
		//}
	}
}

// Draw head of each pip and update hmask
function draw_heads() {
	for (var i = 0; i < instance_number(obj_pip); i++) {
		var pip = instance_find(obj_pip, i)
		
		var head_x = pip.col_head.x
		var head_y = pip.col_head.y
		var head_rot = -pip.col_head.phy_rotation
		
		draw_sprite_ext(spr_pip_head, 0,
			head_x, head_y, 1, 1, head_rot, c_white, 1)
			
		//with(pip.hmask_head) { // update hitmask
		//	x = head_x; y = head_y
		//	image_angle = pip.rotation
		//}
	}
}

// Draw arms of each pip
function draw_arms() {
	for (var i = 0; i < instance_number(obj_pip); i++) {
		var pip = instance_find(obj_pip, i)
		
		var arm_x = pip.col_trunk.x + lengthdir_x(pip.axial_offset_arms, pip.rotation)
		var arm_y = pip.col_trunk.y + lengthdir_y(pip.axial_offset_arms, pip.rotation)
		
		// Draw item in hand
		if (pip.item_x != undefined && pip.item_y != undefined) {
			var item_abs_x = arm_x
				+ lengthdir_x(pip.item_x, pip.rotation)
				+ lengthdir_x(pip.item_y, pip.rotation - 90)
			var item_abs_y = arm_y
				+ lengthdir_y(pip.item_x, pip.rotation)
				+ lengthdir_y(pip.item_y, pip.rotation - 90)
			draw_sprite_ext(spr_snowball, 0,
				item_abs_x, item_abs_y, 1, 1,
				pip.rotation, c_white, 1)
		}
		
		// Draw arms
		if (pip.arm_spr != undefined) {
			draw_sprite_ext(pip.arm_spr, pip.arm_index,
				arm_x, arm_y, 1, 1, pip.rotation, c_white, 1)
		}
	}
}