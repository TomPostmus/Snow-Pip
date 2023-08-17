collision = instance_create_layer(x, y, "Instances", obj_pip_collision)
hmask_head = instance_create_layer(x, y, "Instances", obj_pip_hmask_head)
hmask_head.pip = self
hmask_trunk = instance_create_layer(x, y, "Instances", obj_pip_hmask_trunk)
hmask_trunk.pip = self

player = noone // player inst of this pip
input = noone // input inst to read input from

// Animation vars
rotation = 0					// facing rotation of pip
walk_index = 0					// walk subimage index of trunk sprite
move_axial = 0					// indicates movement on axial axis (-1 back, 1 front)
move_lateral = 0				// indicates movement on lateral axis (-1 right, 1 left)

// Arms animation vars
arm_spr = spr_pip_arm_hold		// spr index of arm(s)
arm_index = 0					// subimage index of arm sprite
arm_state = ANIM_STATE.EMPTY	// anim state of arm
arm_state_changed = false		// whether state of the arm has changed in current step
item_x = undefined				// relative position of holding item
item_y = undefined				// undefined means holding nothing
throw_strength = 0				// value from 0 to 1, how strongly to throw projectile

// Projectiles
projectile_created = false		// whether projectile was created in current step (for synchronization of client)
projectile_info = {}			// struct containing info about projectile created

// Movement sync disable when hit by projectile (for more natural impact effect)
movement_sync_disable_timer = 0 // count down timer for disable movement sync
movement_sync_disable_time = 30	// how many steps to disable movement sync

// Create projectile inst locally
function throw_projectile(_spin) {
	var _arm_x = collision.x + lengthdir_x(8, rotation)
	var _arm_y = collision.y + lengthdir_y(8, rotation)
	var _item_abs_x = _arm_x
		+ lengthdir_x(item_x, rotation) + lengthdir_x(item_y, rotation - 90)
	var _item_abs_y = _arm_y
		+ lengthdir_y(item_x, rotation) + lengthdir_y(item_y, rotation - 90)
	
	var _projectile = instance_create_layer(
		_item_abs_x, _item_abs_y,
		"Instances", obj_snowball)
	_projectile.image_angle = rotation
	_projectile.own_pip = self
		
	var _throw_speed = 7 + throw_strength * 2
	_projectile.speed_x = lengthdir_x(_throw_speed, rotation)
	_projectile.speed_y = lengthdir_y(_throw_speed, rotation)
	_projectile.spin = _spin
	
	// Notify client of projectile creation
	projectile_created = true
	projectile_info = {	// construct projectile info struct
		x: _projectile.x, 
		y: _projectile.y,
		speed_x: _projectile.speed_x,
		speed_y: _projectile.speed_y,
		spin: _projectile.spin,
		type: ITEM.SNOWBALL
	}
}

// Create projectile inst from info received from server
function throw_projectile_remote(_info) {
	var _projectile = instance_create_layer(			// create projectile
		_info.x, _info.y,
		"Instances", obj_snowball)
	_projectile.image_angle = rotation					// set image_angle of projectile to current rotation
	_projectile.own_pip = self
	
	_projectile.speed_x = _info.speed_x
	_projectile.speed_y = _info.speed_y
	_projectile.spin = _info.spin
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