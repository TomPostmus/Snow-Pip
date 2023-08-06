/// @description Create surfaces	
if (!surface_exists(surface_gui))
	surface_gui = surface_create(view_main_w, view_main_h)

if (!surface_exists(surface_log))
	surface_log = surface_create(view_log_w, view_main_h)