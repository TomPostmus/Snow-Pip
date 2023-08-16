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
for (var i = 0; i < ds_list_size(broadcast_anim_update); i ++) { // loop through (potential) broadcast requests
	var _client_connection = broadcast_anim_update[|i][0]
	var _player = broadcast_anim_update[|i][1]
	
	broadcast_packet(
		packgen_animation_update(_player),
		_client_connection			// except client connection from broadcast
	)
}
for (var i = 0; i < ds_list_size(broadcast_projectiles); i ++) {
	var _client_connection = broadcast_projectiles[|i][0]
	var _projectile = broadcast_projectiles[|i][1]
	
	broadcast_packet(
		packgen_projectile_creation(_projectile),
		_client_connection			// except client connection from broadcast
	)
}

// Reset flags
broadcast_game_update = false
broadcast_player_update = false
broadcast_movement_update = false
ds_list_clear(broadcast_anim_update) // clear broadcast requests
ds_list_clear(broadcast_projectiles)

// Catch up with new clients
for (var i = 0; i < ds_list_size(catch_up_clients); i ++) {
	var client_connection = catch_up_clients[|i]
	
	with (client_connection) catch_up()
}
ds_list_clear(catch_up_clients) // clear list

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
	
	// Mid-game spawn/respawn
	with (obj_player) {
		if (hp <= 0) {										// check if dead
			respawn_timer --								// count down respawn timer
			if (respawn_timer <= 0) {						// check if respawn timer has elapsed
				if (other.game.spawn_at_free_spawn(self)) {	// spawn at free spawn (if that succeeds, i.e. there is a free spawn)
					other.broadcast_packet(					// broadcast player spawn
						other.packgen_spawn_player(self)
					
				); show_debug_message("Spawned " + name)}
			}
		}
	}
	
	// Broadcast player movement
	broadcast_movement_timer --
	if (broadcast_movement_timer <= 0) {
		broadcast_movement_update = true // notify broadcast service
		broadcast_movement_timer = broadcast_movement_period // reset timer
	}
}