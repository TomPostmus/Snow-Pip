collision = instance_create_layer(x, y, "Instances", obj_pip_collision)
hmask_head = instance_create_layer(x, y, "Instances", obj_pip_hmask_head)
hmask_trunk = instance_create_layer(x, y, "Instances", obj_pip_hmask_trunk)

// Animation vars
rotation = 0					// facing rotation of pip
walk_index = 0					// walk subimage index of trunk sprite
arm_spr = spr_pip_arm_hold		// spr index of arm(s)
arm_index = 0					// subimage index of arm sprite
arm_state = "hold"				// anim state of arm

// Input vars for animation
input_lateral = 0
input_axial = 0
input_mb_left = 0 // hold left
input_mb_left_press = 0
input_mb_left_release = 0

function throw_projectile(type) {
	var snowball = instance_create_layer(
		collision.x + lengthdir_x(20, rotation),
		collision.y + lengthdir_y(20, rotation),
		"Instances", obj_snowball)
		
	var throw_speed = 10
	snowball.speed_x = lengthdir_x(throw_speed, rotation)
	snowball.speed_y = lengthdir_y(throw_speed, rotation)
	snowball.own_pip = self
}