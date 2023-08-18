// Despawn player (when instructed by server)
if (despawn) {
	if (instance_exists(pip))					// destroy pip
		instance_destroy(pip)
		
	despawn = false								// reset flag
}

// Spawn player (when instructed by server)
if (spawn) {
	if (obj_game.state == GAME_STATE.GAME) {	// if in game state
		if (instance_exists(pip))				// in case of respawn, destroy old pip
			instance_destroy(pip)
		
		pip = instance_create_layer(			// create new pip
			received_x, received_y,
			"Instances", obj_pip
		)
		pip.rotation = received_rot				// spawn with received rotation
		
		pip.player = self						// pass self and input insts
		pip.input = input
		
		hp = 100								// set hp to full
		
		spawn = false							// reset flag
	}
}

// Hp change
hp_changed = hp_prev != hp						// indicate whether hp changed
hp_prev = hp									// update hp_prev