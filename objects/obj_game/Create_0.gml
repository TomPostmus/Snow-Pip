// Game state
state = undefined

// Player id lists
players = ds_list_create() // list of playids received by server
local_players = ds_list_create() // list of this client's playids received by server

// Switch room based on game state
function switch_room() {
	switch (state) {
		case GAME_STATE.LOBBY: var new_room = lobby; break
		case GAME_STATE.GAME:  var new_room = stage_maze; break
	}
	
	// switch
	if (new_room != room)
		room_goto(new_room)
}

// Find player based on player id
function find_player(playid) {
	with (obj_player) {
		if (self.playid == playid)
			return self
	}
	
	return noone
}

// Remove or add players based on player list received from server
function update_player_list() {	
	// add new players
	for (var i = 0; i < ds_list_size(players); i ++) {
		var pl_id = players[|i];
				
		var player = find_player(pl_id)
		
		// create new player
		if (player == noone) {			
			var local = ds_list_find_index(local_players, pl_id) != -1 // whether it is a local player
			var type = local ? obj_player_local : obj_player // which type of player to create
			
			player = instance_create_layer(0, 0,
				"Instances", type)
				
			player.playid = pl_id
		}
	}
	
	// remove left players
	with (obj_player) {
		if (ds_list_find_index(other.players, playid) == -1) {
			instance_destroy()
		}
	}
}