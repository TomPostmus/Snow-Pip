function unique_player_id(){
	// Build temporary list of player ids
	var player_ids = ds_list_create()
	with (obj_player)
		ds_list_add(player_ids, player_id)
	
	// Try to find new player id
	var new_id = 0
	while (ds_list_find_index(
			player_ids, new_id) != -1) {
		new_id ++
	}
		
	return new_id
}