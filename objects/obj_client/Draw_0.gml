// Draw connect state
if (!connected) {
	draw_text(20, 20, "Connecting...")
	draw_text(20, 40, "Current state: " + connect_state)
}

// Draw lobby
if (connected && game.state == GAME_STATE.LOBBY) {
	for (var i = 0; i < ds_list_size(game.players); i ++) {
		var pl_id = game.players[|i]
		var player = game.find_player(pl_id)
		
		draw_text(20, 20 + i * 20,
			"Player " + string(pl_id) + ": " + player.name)
	}
}