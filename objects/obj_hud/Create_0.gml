// Displaying info of pips (name, hp)
pip_info_timer = ds_map_create()		// map from pip inst to info display timer, which is for how long to display info (hp, name)
pip_hp_timer = ds_map_create()			// map from pip inst to hp dislay timer, which is for how long to display hp
pips_in_sight = ds_list_create()		// list of pip insts in sight of camera
pips_in_sight_prev = ds_list_create()	// list of pip insts that were in sight of camera previous step

camera = noone					// camera inst to get info from