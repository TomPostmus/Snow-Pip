// Initial game state
state = GAME_STATE.LOBBY

respawn_time = 300 // how many steps to wait for respawn

// Find player based on player id
function find_player(playid) {
	with (obj_player) {
		if (self.playid == playid)
			return self
	}
	
	return noone
}

// Get unique list of players
function unique_playid() {
	var playids = playid_list()
	
	// Try to find new player id
	var new_id = 0
	while (ds_list_find_index(
			playids, new_id) != -1) {
		new_id ++
	}
		
	return new_id
}

// Return list of player ids
function playid_list() {
	var playids = ds_list_create()
	
	with (obj_player)
		ds_list_add(playids, playid)
	
	return playids
}

// Spawn players at start spawns
function start_spawn_players() {
	for (var i = 0; i < instance_number(obj_player); i ++) {
		var spawn = instance_find(obj_spawn, i)
		var player = instance_find(obj_player, i)
		
		player.x = spawn.x
		player.y = spawn.y
		player.rotation = irandom(360) // random rotation
		
		player.hp = 100
	}
}

// Find a free spawn and spawn a given player there
function spawn_at_free_spawn(player) {
	var spawns = ds_list_create()
	with (obj_spawn) ds_list_add(spawns, self)			// build list of spawns
	
	ds_list_shuffle(spawns)								// shuffle so loop through list in random order
	for (var i = 0; i < ds_list_size(spawns); i ++) {
		var spawn = spawns[|i]
		
		//if (spawn free) {// TODO implement
		
		player.x = spawn.x
		player.y = spawn.y
		player.rotation = irandom(360) // random rotation
		
		player.hp = 100
		
		return true										// return true, i.e. free spawn found
		
		// }
	}
	
	return false										// if no free spawn found, return false
}