// Pulverise effect consists of:
// Cloud
// 4 big parts
// Several small parts

function part(_spr, _x, _y, _rot, _alpha) constructor {
	x = _x; // relative position, to parent position
	y = _y;
	
	spr = _spr;
	rot = _rot;
	alpha = _alpha;
	
	speed_x = 0;
	speed_y = 0;
	speed_rot = 0;
	speed_alpha = 0;
}

parts = ds_list_create()

// Cloud
cloud = new part(spr_snowball_cloud, 
	0, 0, irandom(360), 0.6)
cloud.speed_rot = random_range(0.1, -0.1)
ds_list_add(parts, cloud)
cloud_appear = true

// Big parts
var off = irandom(90)
big_parts = ds_list_create()
for (var i = 0; i < 4; i ++) {
	var angle = off + i * 90
	var prt = new part(
		choose(spr_snowball_part_big1,
			   spr_snowball_part_big2),
		lengthdir_x(2, angle),
		lengthdir_y(2, angle), 
		irandom(360), 1)
		
	prt.speed_x = lengthdir_x(0.5, angle)
	prt.speed_y = lengthdir_y(0.5, angle)
	//prt.speed_alpha = random_range(-0.08, -0.04)
	
	ds_list_add(parts, prt)
	ds_list_add(big_parts, prt)
}

// Small parts
var number = irandom_range(4, 8)
var angle = irandom_range(40, 90)
for (var i = 0; i < number; i ++) {
	var prt = new part(spr_snowball_part_small,
		0, 0, angle, 1)
	
	prt.speed_x = lengthdir_x(3.5, angle)
	prt.speed_y = lengthdir_y(3.5, angle)
	prt.speed_alpha = random_range(-0.10, -0.07)
	
	ds_list_add(parts, prt)
	angle += irandom_range(40, 90)
}