/// @description Create surfaces
if (!surface_exists(surface_main))
	surface_main = surface_create(surface_main_w, surface_main_h) 
	
if (!surface_exists(surface_gui))
	surface_gui = surface_create(surface_main_w, surface_main_h)

if (!surface_exists(surface_log))
	surface_log = surface_create(surface_log_w, surface_main_h)