// Walk animation
walk_index += input_axial * 0.5
if (input_axial == 0) walk_index = 0

// Arms animation and functionality
if (arm_state == "brace") {
	arm_spr = spr_pip_arm_brace
	arm_index += 0.1 // slowly advance animation
	arm_index = min(arm_index, sprite_get_number(arm_spr)-1) // cap at max frame
	
	if (input_mb_left_release) {
		arm_state = "hold"
		throw_projectile("snowball")
	}
} else if (arm_state == "hold") {
	arm_spr = spr_pip_arm_hold
	arm_index = 0
	
	if (input_mb_left_press)
		arm_state = "brace"
} else
	throw ("Unknown animation state for Pip arms, inst:" + string(id))