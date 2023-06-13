collision = instance_create_layer(x, y, "Instances", obj_pip_collision)
hmask_head = instance_create_layer(x, y, "Instances", obj_pip_hmask_head)
hmask_trunk = instance_create_layer(x, y, "Instances", obj_pip_hmask_trunk)

// Animation vars
rotation = 0 // facing rotation of pip
walk_index = 0 // walk subimage index of trunk sprite

// Input vars for animation
input_lateral = 0
input_axial = 0