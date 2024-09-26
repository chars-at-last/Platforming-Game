class_name Interactive extends RigidBody2D


# Constant
const SOLIDS_LAYER: int = 512

# Variable(s)
@export var pushable: bool = true
@export var solid: bool = true


# Disable
func disable() -> void:
	freeze = true
	process_mode = Node.PROCESS_MODE_DISABLED
	self.collision_layer &= 0xFFFFFF - SOLIDS_LAYER

# Enable
func enable() -> void:
	freeze = false
	process_mode = Node.PROCESS_MODE_INHERIT
	
# Make solid
func make_solid() -> void:
	if solid:
		self.collision_layer |= SOLIDS_LAYER
	
# Throw
func throw(force: float, direction: Vector2, mitigated: bool = false) -> void:
	enable()
	#linear_velocity += direction * force
	self.apply_central_impulse(force * direction)
