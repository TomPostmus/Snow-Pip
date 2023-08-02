// Broadcasting service
if (broadcast_game_update) {
	broadcast_packet(
		packgen_game_update()
	)
}
if (broadcast_player_update) {
	broadcast_packet(
		packgen_player_update()
	)
}

// set flags to false
broadcast_game_update = false
broadcast_player_update = false

// Lobby state
if (game.state == GAME_STATE.LOBBY) {
	if (keyboard_check_pressed(vk_space)) {
		game.state = GAME_STATE.GAME
		
		broadcast_game_update = true
	}
}