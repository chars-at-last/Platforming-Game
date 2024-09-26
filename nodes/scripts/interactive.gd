class_name Interactive extends CharacterBody2D


# Constant
const SOLIDS_LAYER: int = 512

# Variable(s)
@export_range(0, 1, .05) var linear_damping: float = .1

@export var pushable: bool = true
@export var solid: bool = true


# Physics process
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		self.velocity += get_gravity() * delta
	else:
		self.velocity.y = min(self.velocity.y, 0)

	if is_on_floor() or is_on_ceiling() and self.velocity.x:
		self.velocity.x *= (1 - linear_damping)
		
	move_and_slide()

# Disable
func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	self.collision_layer &= 0xFFFFFF - SOLIDS_LAYER

# Enable
func enable(make_solid_check: Callable = Callable()) -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	if not make_solid_check.is_null() and make_solid_check.call(self):
		make_solid()
	
# Make solid
func make_solid() -> void:
	if solid:
		self.collision_layer |= SOLIDS_LAYER
	
# Throw
func throw(force: float, direction: Vector2, mitigated: bool = false, make_solid_check: Callable = Callable()) -> void:
	enable(make_solid_check)
	self.velocity += force * direction
