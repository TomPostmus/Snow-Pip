/// @description draw network debug

// Draw packet log
var _max_size = 20 // how many entries to draw maximally
var _draw_list = ds_list_create() // list of tuples, packet type name, consecutive amount, to draw
for (var i = ds_list_size(packet_log)-1; i >= 0; i --) {
	var _type = packet_log[|i]
	
	var _consecutive = 1								// loop ahead to check for consecutive packets
	while (i > 0 && packet_log[|i-1] == _type) {
		i --
		_consecutive ++
	}
	
	var _str = pack_to_string(_type)					// get string of packet type
	ds_list_insert(_draw_list, 0, [_str, _consecutive])	// add tuple to top of draw list
	
	if (ds_list_size(_draw_list) >= _max_size)			// if draw list is maximum size, stop
		break
}

var _list_x = display_get_gui_width() - 200
var _list_y = 40
var _list_w = 180
for (var i = 0; i < ds_list_size(_draw_list); i ++) {
	var _type = _draw_list[|i][0]
	var _consecutive = _draw_list[|i][1]
	
	draw_text(_list_x, _list_y + i * 20, _type)
	
	draw_set_halign(fa_right)
	if (_consecutive > 0)
		draw_text(_list_x + _list_w, _list_y + i * 20, _consecutive)
		
	draw_set_halign(fa_left)
}
ds_list_destroy(_draw_list)