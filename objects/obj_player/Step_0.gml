// Spawn player (when instructed by server)
if (spawn) {
	if (obj_game.state == GAME_STATE.GAME) { // if in game state
		if (instance_exists(pip)) // in case of respawn
			instance_destroy(pip)
		
		pip = instance_create_layer(spawn_x, spawn_y,
			"Instances", obj_pip)
		pip.rotation = spawn_rotation
		
		spawn = false // reset flag
	}
}

// Update position (received from server)
if (next_position) {
	if (instance_exists(pip)) { // check that player is still alive
		pip.collision.phy_position_x = next_x
		pip.collision.phy_position_y = next_y
		pip.rotation = next_rot
	}
	next_position = false // reset flag
}