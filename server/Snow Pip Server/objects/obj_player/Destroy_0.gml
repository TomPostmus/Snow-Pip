/// @description destroy hitmasks
if (instance_exists(hmask_head)) {
	instance_destroy(hmask_head)
	instance_destroy(hmask_trunk)
}