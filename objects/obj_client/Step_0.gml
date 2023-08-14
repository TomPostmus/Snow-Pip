// Sequential client connection state machine
if (connect_state == "await_connection") {
	if (received_server_connection) {
		connect_state = "send_hello"
	}
} else if (connect_state == "send_hello") {
	send_hello()						// send hello request
	
	connect_state = "await_hello"
} else if (connect_state == "await_hello") {
	if (received_hello)
		connect_state = "await_game_update"
		
} else if (connect_state == "await_game_update") {
	if (received_game_update) {
		game.switch_room()				// go to correct room
		game.update_player_list()		// create players
		
		connect_state = "send_player_update"
	}
	
} else if (connect_state == "send_player_update") {
	connect_state = "connected"
	connected = true
	
	send_player_update() // send information of local players
}

// Game state
if (game.state == GAME_STATE.GAME) {
	// send movement updates
	send_movement_timer --
	if (send_movement_timer <= 0) {
		send_movement_update() // send packet
		send_movement_timer = send_movement_period // reset timer
	}
}