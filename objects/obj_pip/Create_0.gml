collision = instance_create_layer(x, y, "Instances", obj_pip_collision)
hmask_head = instance_create_layer(x, y, "Instances", obj_pip_hmask_head)
hmask_head.pip = self
hmask_trunk = instance_create_layer(x, y, "Instances", obj_pip_hmask_trunk)
hmask_trunk.pip = self

// Animation vars
rotation = 0					// facing rotation of pip
walk_index = 0					// walk subimage index of trunk sprite
arm_spr = spr_pip_arm_hold		// spr index of arm(s)
arm_index = 0					// subimage index of arm sprite
arm_state = "hold"				// anim state of arm
item_x = undefined				// relative position of holding item
item_y = undefined				// undefined means holding nothing
throw_strength = 0				// value from 0 to 1, how strongly to throw projectile

// Input vars for animation
input_axial = 0
input_lateral = 0
input_mb_left = 0 // hold left
input_mb_left_press = 0
input_mb_left_release = 0
input_mb_right = 0 // hold right
input_mb_right_press = 0
input_mb_right_release = 0

// Create projectile inst
function throw_projectile(spin) {
	var arm_x = collision.x + lengthdir_x(8, rotation)
	var arm_y = collision.y + lengthdir_y(8, rotation)
	var item_abs_x = arm_x
		+ lengthdir_x(item_x, rotation) + lengthdir_x(item_y, rotation - 90)
	var item_abs_y = arm_y
		+ lengthdir_y(item_x, rotation) + lengthdir_y(item_y, rotation - 90)
	
	var snowball = instance_create_layer(
		item_abs_x, item_abs_y,
		"Instances", obj_snowball)
	snowball.image_angle = rotation
		
	var throw_speed = 7 + throw_strength * 2
	snowball.speed_x = lengthdir_x(throw_speed, rotation)
	snowball.speed_y = lengthdir_y(throw_speed, rotation)
	snowball.own_pip = self
	snowball.spin = spin
}

// Set position of item based on current sprite
function update_item_pos() {
	switch (arm_spr) {
		case spr_pip_arm_hold:
			item_x = 12; item_y = 12
		break
		case spr_pip_arm_brace:
			var index = floor(arm_index)
			switch(index) {
				case 0:
					item_x = 12; item_y = 12
				break
				case 1:
					item_x = 10; item_y = 13
				break
				case 2:
					item_x = 8; item_y = 13
				break
				case 3:
					item_x = 6; item_y = 14
				break
			}
		break
		case spr_pip_arm_throw:		
		case spr_pip_arm_throw_spin:		
			var index = floor(arm_index)
			switch(index) {
				case 0:
					item_x = 12; item_y = 12
				break
				default:
					item_x = undefined; item_y = undefined
				break
			}
		break
		case spr_pip_arm_pickup:
			var index = floor(arm_index)
			switch(index) {
				case 0:
					item_x = 9; item_y = 3
				break
				case 1:
					item_x = 12; item_y = 5
				break
				case 2:
					item_x = 13; item_y = 8
				break
				case 3:
					item_x = 12; item_y = 10
				break
				case 4:
					item_x = 12; item_y = 12
				break
			}
		break		
		case undefined:
			item_x = undefined; item_y = undefined
		break
	}
}