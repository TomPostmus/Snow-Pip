// Find camera
camera = instance_find(obj_camera, 0)

if (instance_exists(camera)) {
	// Make lists of pips in sight
	ds_list_copy(pips_in_sight_prev, pips_in_sight)		// define previous list
	ds_list_clear(pips_in_sight)						// clear list
	for (var i = 0; i < instance_number(obj_pip); i ++) {
		var _pip = instance_find(obj_pip, i)
		
		var _center_dir = point_direction(
			_pip.collision.x, _pip.collision.y,
			camera.x, camera.y
		)
		var _x = _pip.collision.x						// choose a point more towards center of camera for larger margin whether pip is in sight
			+ lengthdir_x(20, _center_dir)
		var _y = _pip.collision.y
			+ lengthdir_y(20, _center_dir)
		
		if (camera.point_in_sight(_x, _y)) {
			ds_list_add(pips_in_sight, _pip)			// add to list		
			
			// set info timer for pips freshly in screen
			if (ds_list_find_index(
				pips_in_sight_prev, _pip) == -1) {		// check if this pip just popped in screen
				pip_info_timer[? _pip] = 300			// set timer
			}
		}		
	}
}