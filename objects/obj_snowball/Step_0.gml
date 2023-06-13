// Fly!
x += speed_x; y += speed_y

// Hit detection
var wall = instance_place(x, y, obj_wall_collision)
var head = instance_place(x, y, obj_pip_hmask_head)
var trunk = instance_place(x, y, obj_pip_hmask_trunk)
var hit = (wall != noone)
	|| (head != noone && head != own_pip.hmask_head)
	|| (trunk != noone && trunk != own_pip.hmask_trunk)

if (hit) {
	pulverise_effect()
	instance_destroy()
}