// Walk animation
move_axial = input.forward - input.backward
move_lateral = input.left - input.right

walk_index += move_axial * 0.5
if (move_axial == 0) walk_index = 0

// Arms animation and functionality
if (arm_state == "hold") {
	arm_index = 0
	
	if (input.mouse_left_press || input.mouse_right_press) {
		arm_state = "brace"
		arm_spr = spr_pip_arm_brace
		throw_strength = 0 // reset throw strength
	}
} if (arm_state == "brace") {					// no elseif for immediate response
	throw_strength += 0.02						// increase throw strength
	throw_strength = min(throw_strength, 1)		// cap at 1
	
	arm_index = throw_strength * 3
	
	if (input.mouse_left_release) {
		arm_state = "throw"
		arm_spr = spr_pip_arm_throw
		arm_index = 0
		
		throw_projectile(false)
	}
	if (input.mouse_right_release) {
		arm_state = "throw_spin"
		arm_spr = spr_pip_arm_throw_spin
		arm_index = 0
		
		throw_projectile(true)
	}
} else if (arm_state == "throw") {
	var t = 0.7
	arm_index += t
	
	if (arm_index > sprite_get_number(arm_spr)-t) {
		arm_state = "empty"
		arm_spr = undefined // no sprite
		arm_index = 0
	}
} else if (arm_state == "throw_spin") {
	var t = 0.7
	arm_index += t
	
	if (arm_index > sprite_get_number(arm_spr)-t) {
		arm_state = "empty"
		arm_spr = undefined // no sprite
		arm_index = 0
	}
} else if (arm_state == "empty") {
	if (input.mouse_left_press || input.mouse_right_press) {
		arm_state = "pickup"
		arm_spr = spr_pip_arm_pickup
		arm_index = 0		
	}
} else if (arm_state == "pickup") {
	var t = 0.5
	arm_index += t
	
	if (arm_index > sprite_get_number(arm_spr)-t) {
		arm_state = "hold"
		arm_spr = spr_pip_arm_hold
		arm_index = 0
	}
}

// Update item pos in hand
update_item_pos()

// Move from local input
if (player.local) {
	// Translational movement
	var _disp_axial, _disp_lateral					// translational displacement on axial and lateral axes
	_disp_axial =
		(input.forward * 1.7 - input.backward * 1.2)// slightly slower backwards speed than forwards
		* !(input.forward && input.backward)		// if both forward & backward are pressed, movement is zero
	_disp_lateral = (input.left - input.right) * 0.8
	
	collision.phy_position_x +=						// update position
		lengthdir_x(_disp_axial, rotation) +
		lengthdir_x(_disp_lateral, rotation + 90)
	collision.phy_position_y += 
		lengthdir_y(_disp_axial, rotation) +
		lengthdir_y(_disp_lateral, rotation + 90)
	
	// Rotation movement from mouse
	var _sensitivity = 0.8							// sensitivity of rotational movement
	var _max_disp_rotation = 20						// maximum rotation displacement each time step
	var _disp_rot									// rotational displacement
	
	_disp_rot = -input.mouse_move_h * _sensitivity	// multiply with sensitivity
	_disp_rot = clamp(_disp_rot,					// clamp rotation
		-_max_disp_rotation, _max_disp_rotation)
		
	rotation += _disp_rot							// update rotation
}

// Move from server input
if (!player.local) {
	collision.phy_position_x = player.received_x
	collision.phy_position_y = player.received_y
	rotation = player.received_rot
}