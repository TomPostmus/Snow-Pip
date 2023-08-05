// Get state
var state = ""
if instance_exists(obj_game)
	state = obj_game.state

// Draw lobby state
if (state == GAME_STATE.LOBBY) {		
	draw_set_colour(c_white)
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
if (state == GAME_STATE.GAME) {
		
	// Draw player icons
	draw_set_colour(c_red)
	with (obj_player) {
		draw_circle(x, y, 10, false)
	}
	
	surface_set_target(surface_log)
	
	draw_clear(c_black)
	
	draw_set_color(c_white)
	draw_text(20, 20, "The game is running...")
	
	// Draw player list
	draw_set_colour(c_white)
	var i = 0
	with (obj_player) {
		if (player_id != undefined) {
			var str = name + ": " + string(player_id)
			draw_text(20, 20 + i * 20, str)
			i ++
		}
	}
	
	surface_reset_target()
	
}

// Draw surfaces
if (view_current == 1)
	draw_surface(surface_log, 0, 0)