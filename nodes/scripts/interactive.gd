class_name Interactive extends RigidBody2D


# Variable(s)
@export var pushable: bool = true


# Disable
func disable() -> void:
	freeze = true
	collision_layer = 0
	process_mode = Node.PROCESS_MODE_DISABLED
