// Initial game state
state = GAME_STATE.LOBBY

respawn_time = 300 // how many steps to wait for respawn

// Find player based on player id
function find_player(player_id) {
	with (obj_player) {
		if (self.player_id == player_id)
			return self
	}
	
	return noone
}

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

function spawn_at_free_spawn(player) {

}