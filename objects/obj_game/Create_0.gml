// Game state
state = undefined

// Players
players = ds_list_create()
local_players = ds_list_create()

// Find player based on player id
function find_player(player_id) {
	with (obj_player) {
		if (self.player_id == player_id)
			return self
	}
	
	return noone
}

// Set local property 
function set_local_players(local_player_ids) {
	for (var i = 0; i < ds_list_size(player_ids); i ++) {
		var player_id = player_ids[|i];
		
		var player = find_player(player_id)
		
		if (player == noone) {
			throw "Trying to set local property of non-existent player"
		}
		
		player.local = true
	}
}

// Remove or add players based on player list received from server
function update_player_list(player_ids) {
	// add new players
	for (var i = 0; i < ds_list_size(player_ids); i ++) {
		var player_id = player_ids[|i];
		
		var player = find_player(player_id)
		
		// create new player
		if (player == noone) {
			player = instance_create_layer(0, 0,
				"Instances", obj_player)
				
			player.player_id = player_id
		}
	}
	
	// remove left players
	with (obj_player) {
		if (ds_list_find_index(
			player_ids,player_id) == -1)
			instance_destroy()
	}
}