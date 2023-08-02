// Sequential client connection state machine
if (connect_state == "send_hello") {
	send_hello()						// send hello request
	
	connect_state = "await_hello"
} if (connect_state == "await_hello") {
	if (received_hello)
		connect_state = "await_game_update"
		
} if (connect_state == "await_game_update") {
	if (received_game_update) {
		game.switch_room()				// go to correct room
		game.update_player_list()		// create players
		
		connect_state = "send_player_update"
	}
	
} if (connect_state == "send_player_update") {
	connect_state = "connected"
	connected = true
	
	send_player_update() // send information of local players
}