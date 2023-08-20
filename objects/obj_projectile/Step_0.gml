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
var _solid = instance_place(x, y, obj_parent_solid)
var _head = instance_place(x, y, obj_pip_hmask_head)
var _trunk = instance_place(x, y, obj_pip_hmask_trunk)
var _hit = (_solid != noone)
	|| (_head != noone && _head != own_pip.hmask_head)
	|| (_trunk != noone && _trunk != own_pip.hmask_trunk)

if (_hit) {
	instance_destroy()
	
	if (_head != noone)
		impact_pip(_head.pip)
	if (_trunk != noone)
		impact_pip(_trunk.pip)
}