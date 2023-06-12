// Draw body
draw_sprite_ext(spr_pip_trunk, 0,
	collision.x + lengthdir_x(0, rotation),
	collision.y + lengthdir_y(0, rotation),
	1, 1, rotation, c_white, 1)
	
// Draw head
draw_sprite_ext(spr_pip_head, 0,
	collision.x + lengthdir_x(5, rotation),
	collision.y + lengthdir_y(5, rotation),
	1, 1, rotation, c_white, 1)