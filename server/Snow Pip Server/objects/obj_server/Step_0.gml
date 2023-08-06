// Broadcasting service
if (broadcast_game_update) {
	broadcast_packet(
		packgen_game_update()
	)
}
if (broadcast_player_update) {
	broadcast_packet(
		packgen_player_update()
	)
}
if (broadcast_movement_update) {
	broadcast_packet(
		packgen_movement_update()
	)
}

// Reset flags
broadcast_game_update = false
broadcast_player_update = false
broadcast_movement_update = false

// Lobby state
if (game.state == GAME_STATE.LOBBY) {
	// switch to game state
	if (keyboard_check_pressed(vk_space)) {
		game.state = GAME_STATE.GAME
		broadcast_game_update = true // notify clients
		
		room_goto(stage_maze) // switch room
		start_state = true
	}
} else if (game.state == GAME_STATE.GAME) {
	// Start spawns
	if (start_state) { // initial step of state
		start_state = false // reset start state
		
		game.start_spawn_players() // spawn players at start locations
		
		// broadcast player spawns
		with (obj_player) {
			other.broadcast_packet(
				other.packgen_spawn_player(self)
			)
		}
	}
	
	// Broadcast player movement
	broadcast_movement_timer --
	if (broadcast_movement_timer <= 0) {
		broadcast_movement_update = true // notify broadcast service
		broadcast_movement_timer = broadcast_movement_period // reset timer
	}
}