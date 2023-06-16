// Walk animation
walk_index += input_axial * 0.5
if (input_axial == 0) walk_index = 0

// Arms animation and functionality
if (arm_state == "hold") {
	arm_index = 0
	
	if (input_mb_left_press) {
		arm_state = "brace"
		arm_spr = spr_pip_arm_brace
	}
} if (arm_state == "brace") { // no elseif for immediate response
	arm_index += 0.1 // slowly advance animation
	arm_index = min(arm_index, sprite_get_number(arm_spr)-1) // cap at max frame
	
	if (input_mb_left_release) {
		arm_state = "throw"
		arm_spr = spr_pip_arm_throw
		arm_index = 0
		
		throw_projectile("snowball")
	}
} else if (arm_state == "throw") {
	var t = 0.5
	arm_index += t
	
	if (arm_index > sprite_get_number(arm_spr)-t) {
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