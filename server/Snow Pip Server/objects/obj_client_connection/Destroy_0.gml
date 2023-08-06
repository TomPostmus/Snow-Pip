// Remove player objs belonging to this client connection
for (var i = 0; i < ds_list_size(client_players); i ++) {
	var pl_id = client_players[|i]
	var player = game.find_player(pl_id)
	instance_destroy(player)
}