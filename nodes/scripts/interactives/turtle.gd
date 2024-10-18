class_name Turtle extends Interactive


# Constant(s)
const TURTLE_SPEED: float = 20
const SPINNING_SPEED: float = 500
const TURTLE_BOOST: float = -600

enum States {
	WALKING,
	SHELL,
	SPINNING
}

# Variable(s)
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Area2D

@export var facing_dir: float = 1
var ground_vel: Vector2
var _state: States = States.WALKING

# Signal(s)
signal death(body)

# Ready
func _ready() -> void:
	sprite.flip_h = facing_dir < 0
	ground_vel.x = TURTLE_SPEED * facing_dir
	
	if GameManager.current_level_manager:
		connect("death", Callable(GameManager.current_level_manager, "on_death"))

# Physics process
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if _state != States.SHELL:
		if _state == States.SPINNING or is_on_floor():
			velocity.x = ground_vel.x
		else:
			velocity.x = 0
			
		if is_on_wall():
			facing_dir = get_wall_normal().x
			ground_vel.x = abs(ground_vel.x) * facing_dir
			sprite.flip_h = facing_dir < 0

# Handles being picked up
func handle_pickup() -> void:
	update_state(States.SHELL)

# Throw
func _throw_inner(force: float, direction: Vector2, mitigated: bool = false) -> void:
	if not mitigated and direction.x != 0:
		update_state(States.SPINNING, direction.x)
	else:
		update_state(States.SHELL)
		super._throw_inner(force, direction, mitigated)

# Updates state
func update_state(state: States, extra: float = 0) -> void:
	if state != _state:
		_state = state
		
		var temp: Callable = func() -> void:
			if player.is_playing():
				player.stop()
			sprite.frame = 2
			pickable = true
			
		match(_state):
			States.WALKING:
				player.play("default")
			States.SHELL:
				temp.call()
				ground_vel.x = 0
				velocity.x = 0
			States.SPINNING:
				temp.call()
				ground_vel.x = SPINNING_SPEED * extra

# Disable
func disable() -> void:
	#process_mode = Node.PROCESS_MODE_DISABLED
	#self.collision_layer &= 0xFFFFFF - SOLIDS_LAYER
	super.disable()
	area.collision_mask &= 0xFFFFFF - PLAYER_LAYER
	self.collision_mask &= 0xFFFFFF - PLAYER_LAYER
	velocity.y = 0

# Make solid
func make_solid() -> void:
	super.make_solid()
	area.collision_mask |= PLAYER_LAYER
	self.collision_mask |= PLAYER_LAYER

# Signal method(s) #

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.velocity.y > 0:
		update_state(States.SHELL if _state == States.WALKING else States.SPINNING, sign(position.x - body.position.x))
		
		if body is not Player:
			body.velocity.y = TURTLE_BOOST
		else:
			body.jump(TURTLE_BOOST, true)
	elif body.velocity.y <= 0 and _state == States.SPINNING:
		emit_signal("death", body)
