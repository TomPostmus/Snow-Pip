if (instance_exists(camera)) {
	
	// Make lists of pips in sight
	ds_list_copy(pips_in_sight_prev, pips_in_sight)		// define previous list
	ds_list_clear(pips_in_sight)						// clear list
	for (var i = 0; i < instance_number(obj_pip); i ++) {
		var _pip = instance_find(obj_pip, i)
		
		// find point
		var _center_dir = point_direction(
			_pip.collision.x, _pip.collision.y,
			camera.x, camera.y
		)
		var _x = _pip.collision.x						// choose a point more towards center of camera for larger margin whether pip is in sight
			+ lengthdir_x(20, _center_dir)
		var _y = _pip.collision.y
			+ lengthdir_y(20, _center_dir)
		
		// check if point is in sight
		if (camera.point_in_sight(_x, _y)) {
			ds_list_add(pips_in_sight, _pip)			// add to list		
			
			// set info timer for pips freshly in screen
			if (ds_list_find_index(
				pips_in_sight_prev, _pip) == -1) {		// check if this pip just popped in screen
				pip_info_timer[? _pip] = 300			// set timer
			}
			
			// set hp display timer for pips of which hp changed
			if (_pip.player.hp_changed)
				pip_hp_timer[? _pip] = 300
		}		
	}
	
	// Draw info and hp bar of pips
	for (var i = 0; i < ds_list_size(pips_in_sight); i ++) {
		var _pip = pips_in_sight[|i]
	
		// check timer maps
		if (is_undefined(pip_info_timer[? _pip]))			// check if map entry exists
			pip_info_timer[? _pip] = 0						// set to 0 by default
		if (is_undefined(pip_hp_timer[? _pip]))
			pip_hp_timer[? _pip] = 0
	
		// draw name
		if (pip_info_timer[? _pip] > 0) {
			draw_set_colour(c_red)
			draw_set_alpha(pip_info_timer[? _pip] / 100)	// set alpha for fading effect
			draw_set_halign(fa_center)
		
			draw_text(										// draw name
				camera.gui_x(_pip.collision.x),				// convert coords of pip to GUI coords
				camera.gui_y(_pip.collision.y) - 70,
				_pip.player.name
			)		
		
			draw_set_alpha(1)								// reset alpha
			draw_set_halign(fa_left)						// reset halign
		}
		
		// draw hp bar
		var _timer = max(pip_info_timer[? _pip],			// take max of timers (since hp is displayed for both timers)
			pip_hp_timer[? _pip])
		if (_timer > 0) {
			draw_set_alpha(_timer / 100)	// set alpha for fading effect
			
			var _hp = _pip.player.hp						// get hp
			
			var _x = camera.gui_x(_pip.collision.x)			// get position
			var _y = camera.gui_y(_pip.collision.y)
			
			var _w = 64, _h = 2, _y_off = 52				// dimensions of hp bar
			var _w_hp = _hp / 100 * _w						// width of hp part of hp bar
			draw_set_colour(c_red)
			draw_rectangle(									// draw hp bar
				_x - _w / 2, _y - _y_off, 
				_x - _w / 2 + _w_hp, _y - _y_off + _h, 
				false
			)
			
			draw_set_colour(c_black)
			draw_line(										// draw end line
				_x + _w / 2, _y - _y_off,
				_x + _w / 2, _y - _y_off + _h
			)
			
			draw_set_alpha(1)								// reset alpha
		}
		
		// decrease timers
		if (pip_info_timer[? _pip] > 0) 
			pip_info_timer[? _pip] --
		if (pip_hp_timer[? _pip] > 0)
			pip_hp_timer[? _pip] --
	}
}