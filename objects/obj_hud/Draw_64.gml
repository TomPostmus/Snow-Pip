// Draw info of pips
if (instance_exists(camera)) {
	for (var i = 0; i < ds_list_size(pips_in_sight); i ++) {
		var _pip = pips_in_sight[|i]
	
		// check timer map
		if (is_undefined(pip_info_timer[? _pip]))			// check if map entry exists
			pip_info_timer[? _pip] = 0						// set to 0 by default
	
		// draw info
		if (pip_info_timer[? _pip] > 0) {
			draw_set_colour(c_red)
			draw_set_alpha(pip_info_timer[? _pip] / 100)	// set alpha for fading effect
			draw_set_halign(fa_center)
		
			draw_text(										// draw name
				camera.gui_x(_pip.collision.x),				// convert coords of pip to GUI coords
				camera.gui_y(_pip.collision.y) - 50,
				_pip.player.name
			)
		
			pip_info_timer[? _pip] --						// decrease timer
		
			draw_set_alpha(1)								// reset alpha
			draw_set_halign(fa_left)						// reset halign
		}
	}
}