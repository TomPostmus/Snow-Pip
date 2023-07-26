// Sequential client state machine
if (state == "send_hello") {
	
	send_hello() // send hello request
	
	state = "await_hello"
	
} if (state == "await_hello") {
	
	if (received_hello) {
		state = "await_game_update"
	}
	
} if (state == "await_game_update") {
	
	if (received_game_update) {
		game.switch_room() // go to correct room
		game.update_player_list() // create players
		
		state = "send_player_update"
		received_game_update = false
	}
	
} if (state == "send_player_update") {
	
	send_player_update() // send information of local players
	
	state = "listening" // go immediately to general server update listening state
	
}

// Listen for server updates
if (state == "listening") {
	
}