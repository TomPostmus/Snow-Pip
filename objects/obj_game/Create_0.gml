// Game state
state = undefined

// Player id lists
players = ds_list_create() // list of player_ids received by server
local_players = ds_list_create() // list of this client's player_ids received by server

// Switch room based on game state
function switch_room() {
	switch (state) {
		case GAME_STATE.LOBBY: room_goto(lobby)
		case GAME_STATE.GAME: room_goto(stage_maze)
	}
}

// Find player based on player id
function find_player(player_id) {
	with (obj_player) {
		if (self.player_id == player_id)
			return self
	}
	
	return noone
}

// Remove or add players based on player list received from server
function update_player_list() {
	// add new players
	for (var i = 0; i < ds_list_size(players); i ++) {
		var player_id = players[|i];
				
		var player = find_player(player_id)
		
		// create new player
		if (player == noone) {			
			var local = ds_list_find_index(local_players, player_id) != -1 // whether it is a local player
			var type = local ? obj_player_local : obj_player // which type of player to create
			
			player = instance_create_layer(0, 0,
				"Instances", type)
				
			player.player_id = player_id
		}
	}
	
	// remove left players
	with (obj_player) {
		if (ds_list_find_index(
			players, player_id) == -1)
			instance_destroy()
	}
}