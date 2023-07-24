// Remove player objs belonging to this client connection
for (var i = 0; i < ds_list_size(client_players); i ++) {
	instance_destroy(client_players[|i])
}