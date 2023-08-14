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
		if (playid != undefined) {
			var str = name + ": " + string(playid)
			draw_text(20, 40 + i * 20, str)
			i ++
		}
	}
}

// Draw game state
if (state == GAME_STATE.GAME) {
	
	// Draw to GUI surface
	surface_set_target(surface_gui)
	draw_clear_alpha(c_black, 0) // flush surface
	
	// Draw player icons
	draw_set_colour(c_red)
	with (obj_player) {
		if (hp > 0) { // check if alive
			var _x = other.gui_x(x)
			var _y = other.gui_y(y)
			draw_circle(_x, _y, 5, true)
			draw_line(_x, _y,
				_x + lengthdir_x(7, rotation), 
				_y + lengthdir_y(7, rotation)
			)
		}
	}
	
	surface_reset_target()
	
	// Draw to log surface
	surface_set_target(surface_log)
	
	draw_clear(c_black)
	
	// Draw player list
	draw_set_colour(c_white)
	draw_text(20, 20, "Players")
	
	var i = 0
	with (obj_player) {
		if (playid != undefined) {
			var str = string(playid) + ". " + name 
			draw_text(20, 40 + i * 20, str)
			i ++
		}
	}
	
	surface_reset_target()
	
}

// Draw surfaces
if (view_current == 1)
	draw_surface(surface_log, 0, 0)
	
if (view_current == 0) {
	draw_surface_stretched(surface_gui,
		0, 0, room_width, room_height)
}