// Initial game state
state = GAME_STATE.LOBBY

// Get unique list of players
function unique_player_id() {
	var player_ids = player_id_list()
	
	// Try to find new player id
	var new_id = 0
	while (ds_list_find_index(
			player_ids, new_id) != -1) {
		new_id ++
	}
		
	return new_id
}

// Return list of player ids
function player_id_list() {
	var player_ids = ds_list_create()
	
	with (obj_player)
		ds_list_add(player_ids, player_id)
	
	return player_ids
}