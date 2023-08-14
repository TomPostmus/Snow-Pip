// Spawn player (when instructed by server)
if (spawn) {
	if (obj_game.state == GAME_STATE.GAME) { // if in game state
		if (instance_exists(pip)) // in case of respawn
			instance_destroy(pip)
		
		pip = instance_create_layer(received_x, received_y,
			"Instances", obj_pip)
		pip.rotation = received_rot
		
		pip.player = self
		pip.input = input
		
		hp = 100 // set hp to full
		
		spawn = false // reset flag
	}
}