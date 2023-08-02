// Draw lobby state
if (game.state == GAME_STATE.LOBBY) {

	draw_text(20, 20, "Welcome to the lobby.")

	var i = 0
	with (obj_player) {
		if (player_id != undefined) {
			var str = name + ": " + string(player_id)
			draw_text(20, 40 + i * 20, str)
			i ++
		}
	}
}

// Draw game state
if (game.state == GAME_STATE.GAME) {
	
	draw_text(20, 20, "The game is running...")
	
	// Draw player list on the right
	var player_list_y = room_height - instance_number(obj_player) * 20 - 20
	var player_list_x = room_width - 200 - 20
	var i = 0
	with (obj_player) {
		if (player_id != undefined) {
			var str = name + ": " + string(player_id)
			draw_text(player_list_x, player_list_y + i * 20, str)
			i ++
		}
	}
	
}