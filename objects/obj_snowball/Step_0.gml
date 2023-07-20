// Fly!
x += speed_x; y += speed_y

// Spin
if (spin) {
	image_angle -= 45 // sprite spin effect
	
	// Current direction
	var current_dir = point_direction(0, 0, speed_x, speed_y)
	if (spin_init_dir == undefined)
		spin_init_dir = current_dir // set initial moving direction
	
	// Calculate next direction based on spin radius
	var spd = point_distance(0, 0, speed_x, speed_y)
	var max_dir = spin_init_dir - spin_max_turn
	var spin_circumference = 2 * pi * spin_radius
	var next_dir = current_dir - 360 * (spd / spin_circumference) // next dir based on spin radius
	
	if (angle_difference(max_dir, next_dir) > 0) // cap at maximum spin direction (90 deg from initial dir)
		next_dir = max_dir
	
	// Update speed
	speed_x = lengthdir_x(spd, next_dir)
	speed_y = lengthdir_y(spd, next_dir)
} else {
	image_angle += 2 // subtle sprite spin effect
}
	

// Hit detection
var wall = instance_place(x, y, obj_wall_collision)
var head = instance_place(x, y, obj_pip_hmask_head)
var trunk = instance_place(x, y, obj_pip_hmask_trunk)
var hit = (wall != noone)
	|| (head != noone && head != own_pip.hmask_head)
	|| (trunk != noone && trunk != own_pip.hmask_trunk)

if (hit) {
	instance_create_layer(x, y, "Instances", obj_snowball_pulverise)
	instance_destroy()
	
	if (head != noone)
		impact_pip(head.pip)
	if (trunk != noone)
		impact_pip(trunk.pip)
}