// Walk animation
walk_index += input_axial * 0.5
if (input_axial == 0) walk_index = 0

// Arms animation and functionality
if (arm_state == "hold") {
	arm_index = 0
	
	if (input_mb_left_press || input_mb_right_press) {
		arm_state = "brace"
		arm_spr = spr_pip_arm_brace
		throw_strength = 0 // reset throw strength
	}
} if (arm_state == "brace") {					// no elseif for immediate response
	throw_strength += 0.02						// increase throw strength
	throw_strength = min(throw_strength, 1)		// cap at 1
	
	arm_index = throw_strength * 3
	
	if (input_mb_left_release) {
		arm_state = "throw"
		arm_spr = spr_pip_arm_throw
		arm_index = 0
		
		throw_projectile(false)
	}
	if (input_mb_right_release) {
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
	if (input_mb_left_press || input_mb_right_press) {
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