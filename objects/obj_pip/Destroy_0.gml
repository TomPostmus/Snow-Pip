// Destroy collisions
physics_joint_delete(joint)				// delete joint between head and trunk
with (col_head) instance_destroy()
with (col_trunk) instance_destroy()