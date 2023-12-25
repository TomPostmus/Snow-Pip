player = noone			// player inst of this pip
input = noone			// input inst to read input from

// Animation vars
rotation = 0								// facing rotation of pip
walk_index = 0								// walk subimage index of trunk sprite
move_axial = 0								// indicates movement on axial axis (-1 back, 1 front)
move_lateral = 0							// indicates movement on lateral axis (-1 right, 1 left)

// Pip atonomy properties
//axial_offset_trunk = 0					// axial offset of trunk by definition zero since trunk location is pip location
axial_offset_head = 7						// axial offset of head (w.r.t trunk pos)
axial_offset_arms = 8						// axial offset of arms (w.r.t trunk pos)

// Create collision
var trunk_x = x													// location of trunk (same as start pos)
var trunk_y = y
var head_x = x + lengthdir_x(axial_offset_head, rotation)		// location of head
var head_y = y + lengthdir_y(axial_offset_head, rotation)
		
col_trunk = instance_create_layer(			// create trunk collion inst
	trunk_x, trunk_y, "Instances", obj_pip_col_trunk)
col_trunk.pip = self						// give pip inst to head for backtracking in hit detection
col_head = instance_create_layer(			// create head collion inst
	head_x, head_y, "Instances", obj_pip_col_head)
col_head.pip = self							// give pip inst to head for backtracking in hit detection
joint = physics_joint_revolute_create(			// create weld joint between trunk and head
	col_trunk, col_head, trunk_x, trunk_y,
	0, 0, false, 0, 0, false, false)

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
projectile_info = {}			// struct containing info about creation of projectile (initial state)
projectile = noone				// projectile that was created last

// Movement sync disable when hit by projectile (for more natural impact effect of remote enemy)
movement_sync_disable_timer = 0 // count down timer for disable movement sync
movement_sync_disable_time = 30	// how many steps to disable movement sync

// Create projectile inst locally
function throw_projectile(_spin) {
	var _arm_x = col_trunk.x + lengthdir_x(axial_offset_arms, rotation)
	var _arm_y = col_trunk.y + lengthdir_y(axial_offset_arms, rotation)
	var _item_abs_x = _arm_x
		+ lengthdir_x(item_x, rotation) + lengthdir_x(item_y, rotation - 90)
	var _item_abs_y = _arm_y
		+ lengthdir_y(item_x, rotation) + lengthdir_y(item_y, rotation - 90)
	
	projectile = instance_create_layer(
		_item_abs_x, _item_abs_y,
		"Instances", obj_projectile)
	projectile.image_angle = rotation
	projectile.own_pip = self
		
	var _throw_speed = 7 + throw_strength * 2
	projectile.speed_x = lengthdir_x(_throw_speed, rotation)
	projectile.speed_y = lengthdir_y(_throw_speed, rotation)
	projectile.spin = _spin
	projectile.type = ITEM.SNOWBALL
	
	// Notify client of projectile creation
	projectile_created = true
	projectile_info = projectile.generate_info_struct() // save initial state for sending to server
}

// Create projectile inst from info received from server
function throw_projectile_remote(_info) {
	var _projectile = instance_create_layer(			// create projectile
		_info.x, _info.y,
		"Instances", obj_projectile)
	_projectile.image_angle = rotation					// set image_angle of projectile to current rotation
	_projectile.own_pip = self
	
	_projectile.speed_x = _info.speed_x
	_projectile.speed_y = _info.speed_y
	_projectile.spin = _info.spin
	_projectile.type = _info.type
	_projectile.projectile_id = _info.projectile_id
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