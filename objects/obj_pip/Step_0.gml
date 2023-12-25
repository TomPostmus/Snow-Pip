// Walk animation
move_axial = input.forward - input.backward
move_lateral = input.left - input.right

walk_index += move_axial * 0.5
if (move_axial == 0) walk_index = 0

// Arms states animation
if (arm_state == ANIM_STATE.HOLD) {
	arm_index = 0
	arm_spr = spr_pip_arm_hold
	
} else if (arm_state == ANIM_STATE.BRACE) {
	if (arm_state_changed)						// start of state
		throw_strength = 0						// reset throw strength
		
	throw_strength += 0.02						// increase throw strength
	throw_strength = min(throw_strength, 1)		// cap at 1
	
	arm_spr = spr_pip_arm_brace
	arm_index = throw_strength * 3
	
} else if (arm_state == ANIM_STATE.THROW) {
	if (arm_state_changed)						// start of state
		arm_index = 0							// reset arm index
		
	var t = 0.7
	arm_index += t								// advance animation
	arm_spr = spr_pip_arm_throw
	
	arm_index = min(arm_index,					// cap animation
		sprite_get_number(arm_spr)-0.5)
	
} else if (arm_state == ANIM_STATE.THROW_SPIN) {
	if (arm_state_changed)						// start of state
		arm_index = 0							// reset arm index
		
	var t = 0.7
	arm_index += t								// advance animation
	arm_spr = spr_pip_arm_throw_spin
	
	arm_index = min(arm_index,					// cap animation
		sprite_get_number(arm_spr)-0.5)
	
} else if (arm_state == ANIM_STATE.EMPTY) {
	arm_index = 0
	arm_spr = undefined							// no sprite
	
} else if (arm_state == ANIM_STATE.PICKUP) {
	if (arm_state_changed)						// start of state
		arm_index = 0							// reset arm index
		
	var t = 0.5
	arm_index += t								// advance animation
	arm_spr = spr_pip_arm_pickup
	
	arm_index = min(arm_index,					// cap animation
		sprite_get_number(arm_spr)-0.5)
	
}

// Update item pos in hand
update_item_pos()

// Move from local input
if (player.local) {
	// Translational movement
	var _disp_axial, _disp_lateral					// translational displacement on axial and lateral axes
	_disp_axial =
		(input.forward * 2.3 - input.backward * 1.6)// slightly slower backwards speed than forwards
		* !(input.forward && input.backward)		// if both forward & backward are pressed, movement is zero
	_disp_lateral = (input.left - input.right) * 0.8
	
	col_trunk.phy_position_x +=						// update position of trunk
		lengthdir_x(_disp_axial, rotation) +
		lengthdir_x(_disp_lateral, rotation + 90)
	col_trunk.phy_position_y += 
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
	col_trunk.phy_rotation = -rotation				// update trunk rotation
	col_head.phy_rotation = col_trunk.phy_rotation	// update head rotation to trunk rotation
}

// Move from server input
if (!player.local) {
	if (movement_sync_disable_timer <= 0) {			// check if movement sync disable is activated
		// Update position (with some smoothing)
		col_trunk.phy_position_x += 
			(player.received_x - col_trunk.phy_position_x) * 0.6
		col_trunk.phy_position_y += 
			(player.received_y - col_trunk.phy_position_y) * 0.6
	} else
		movement_sync_disable_timer --				// update timer
	
	// Add a small speed component
	var _speed_lateral = (player.received_in_left - player.received_in_right) * 0.2
	var _speed_axial = (player.received_in_forward - player.received_in_backward) * 0.2
	col_trunk.phy_speed_x +=
		lengthdir_x(_speed_axial, rotation) +
		lengthdir_x(_speed_lateral, rotation + 90)
	col_trunk.phy_speed_y +=
		lengthdir_y(_speed_axial, rotation) +
		lengthdir_y(_speed_lateral, rotation + 90)
	
	// Update rotation (with some smoothing)
	rotation += (player.received_rot - rotation) * 0.7
	col_trunk.phy_rotation = -rotation				// update collision rotation
	col_head.phy_rotation = col_trunk.phy_rotation	// update head rotation to trunk rotation
}

// Change arm state from local input
if (player.local) {
	var _prev_state = arm_state
	if (arm_state == ANIM_STATE.HOLD) {	
		if (input.mouse_left_press || input.mouse_right_press)
			arm_state = ANIM_STATE.BRACE
		
	} if (arm_state == ANIM_STATE.BRACE) { // no else if for immediate response
		if (input.mouse_left_release) {
			arm_state = ANIM_STATE.THROW
			throw_projectile(false)
		}
		if (input.mouse_right_release) {
			arm_state = ANIM_STATE.THROW_SPIN		
			throw_projectile(true)
		}
	} else if (arm_state == ANIM_STATE.THROW) {
		if (arm_index == sprite_get_number(arm_spr)-0.5)
			arm_state = ANIM_STATE.EMPTY
		
	} else if (arm_state == ANIM_STATE.THROW_SPIN) {
		if (arm_index == sprite_get_number(arm_spr)-0.5)
			arm_state = ANIM_STATE.EMPTY
		
	} else if (arm_state == ANIM_STATE.EMPTY) {
		if (input.mouse_left_press || input.mouse_right_press)
			arm_state = ANIM_STATE.PICKUP
	
	} else if (arm_state == ANIM_STATE.PICKUP) {
		if (arm_index == sprite_get_number(arm_spr)-0.5) 
			arm_state = ANIM_STATE.HOLD
		
	}
	
	// Check if state changed
	arm_state_changed = (_prev_state != arm_state)
}

// Change arm state from server input
if (!player.local) {
	// Update state
	var _prev_state = arm_state
	arm_state = player.received_arm_state
	
	// Check if state changed
	arm_state_changed = (_prev_state != arm_state)
}

// Create projectile based on server input
if (!player.local && player.received_projectile_creation) {
	var _info = player.received_projectile_info			// get info
	
	throw_projectile_remote(_info)						// create projectile
	
	player.received_projectile_creation = false			// reset flag
}