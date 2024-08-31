@icon("res://icon.svg")

class_name Player extends CharacterBody2D


# Constants
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const VELOCITY_GROUND_NERF: float = .8
const VELOCITY_GROUND_MOVEMENT_NERF: float = .9
const DIFF_DIRECTION_MULT: float = 4

# Variables
var unbridled_velocity: Vector2			## Velocity without restrictions
var acceleration: Vector2				## Rate of change of the velocity
@export var move_accel: float = 10		## What the acceleration is set to when moving

# Process
func _physics_process(delta: float) -> void:
	#print(acceleration.x)
	#print(velocity.x)
	#print(unbridled_velocity.x)
	#print()
	
	# Gravity
	if not is_on_floor():
		if is_on_ceiling():
			unbridled_velocity.y = max(0, unbridled_velocity.y)
		unbridled_velocity += get_gravity() * delta			# Apply gravity here
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		unbridled_velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# Kinda similar to the default CharacterBody2D code, but obvious purposed for our game
	acceleration.x = max(acceleration.x, move_accel)
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction:
		var addition: float = acceleration.x * direction
		if not is_equal_approx(signf(direction), signf(unbridled_velocity.x)):
			addition *= DIFF_DIRECTION_MULT
		unbridled_velocity.x += addition
	#else:
		#unbridled_velocity.x = move_toward(unbridled_velocity.x, 0, acceleration.x)
	
	# Walls
	if is_on_wall():
		unbridled_velocity.x = max(unbridled_velocity.x, 0) if is_equal_approx(get_wall_normal().x, 1.0) else min(unbridled_velocity.x, 0)
	
	# Velocity
	velocity = unbridled_velocity

	# Other floor stuff
	if is_on_floor():
		if not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			velocity.x = floor(velocity.x * VELOCITY_GROUND_NERF)				# Nerf x velocity here
			unbridled_velocity.x = floor(unbridled_velocity.x * VELOCITY_GROUND_NERF)
		else:
			velocity.x = floor(velocity.x * VELOCITY_GROUND_MOVEMENT_NERF)
			#unbridled_velocity *= VELOCITY_GROUND_MOVEMENT_NERF

	move_and_slide()
