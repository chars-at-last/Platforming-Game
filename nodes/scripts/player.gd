@icon("res://icon.svg")

class_name Player extends CharacterBody2D


# Constants
const JUMP_VELOCITY: float = -400.0					## Jump velocity
const VELOCITY_GROUND_NERF: float = .9				## Velocity nerf when on ground
const VELOCITY_GROUND_MOVEMENT_NERF: float = .9		## Velocity nerf when on ground and moving
const DIFF_DIRECTION_MULT: float = 4				## Acceleration multiplier when moving opposite to velocity
const WALL_BOOST_MULT: float = .25					## Velocity multiplier when move-jumping into wall
const WALL_JUMP_ANGLE_R: float = PI * 7.1 / 4		## Wall jump angle (Rightward normal)
const WALL_JUMP_ANGLE_L: float = PI * 4.9 / 4		## Wall jump angle (Leftward normal)

# Variables
@onready var sprite: Sprite2D = $Sprite2D

var direction: float								## Direction of movement

var unbridled_velocity: Vector2						## Velocity without restrictions
var acceleration: Vector2							## Rate of change of the velocity
@export var move_accel: float = 10					## What the acceleration is set to when moving

@export var jump_vel_boost: float = 20				## Boost to velocity when jumping off ground
@export var wall_jump_vel_boost: float = 500		## Boost to velocity when jumping off wall
var _wall_normal: Vector2							## Wall normal

var _switching_dir: bool = false					## Flag for switching direction
var _wall_boosted: bool = false						## Flag if move-jumping into wall
var _can_wall_jump: bool = false					## Flag if can wall jump

# Process
func _physics_process(delta: float) -> void:
	#print(acceleration.x)
	#print(velocity.x)
	#print(unbridled_velocity.x)
	#print(_switching_dir)
	#print(_can_wall_jump)
	#print(_wall_normal)
	#print()
		
	physics_gravity(delta)				# Gravity stuff
	physics_direction(delta)			# Directional stuff
	physics_jump(delta)					# Jump stuff
	physics_wall(delta)					# Wall stuff
	
	# Velocity
	velocity = unbridled_velocity		# Velocity
	
	face()								# Which way is the character facing

	physics_floor(delta)				# Floor stuff
	move_and_slide()

# Facing direction
func face() -> void:
	if direction:
		sprite.flip_h = direction < 0

# Gravity and other stuff
func physics_gravity(delta: float) -> void:
	if not is_on_floor():
		if not is_on_wall():
			if _wall_boosted:
				_wall_boosted = false
		
		if is_on_ceiling():
			unbridled_velocity.y = max(0, unbridled_velocity.y)
		unbridled_velocity += get_gravity() * delta			# Apply gravity here
	else:
		unbridled_velocity.y = 0
		if _switching_dir:
			_switching_dir = false

# Get the input direction and handle the acceleration/deceleration.
func physics_direction(_delta: float) -> void:
	acceleration.x = max(acceleration.x, move_accel)
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		var addition: float = acceleration.x * direction
		
		var same_signs: bool = is_equal_approx(signf(direction), signf(unbridled_velocity.x))
		if not is_on_floor():
			if not same_signs:
				_switching_dir = true
		else:
			if not same_signs:
				_switching_dir = true
			elif _switching_dir:
				_switching_dir = false
			
		if _switching_dir:
			addition *= DIFF_DIRECTION_MULT
		unbridled_velocity.x += addition
	elif _switching_dir:
		_switching_dir = false

# Handle jump
func physics_jump(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		unbridled_velocity.y = JUMP_VELOCITY
		unbridled_velocity.x += jump_vel_boost * direction

# Walls
func physics_wall(_delta: float) -> void:
	if is_on_wall():
		_wall_normal = get_wall_normal()
		
		var cur_ubvel_x: float = unbridled_velocity.x
		unbridled_velocity.x = max(unbridled_velocity.x, 0) if is_equal_approx(_wall_normal.x, 1.0) else min(unbridled_velocity.x, 0)
		
		if not (is_on_floor() or _wall_boosted) and signf(unbridled_velocity.y) < 0:
			var diff: float = abs(cur_ubvel_x - unbridled_velocity.x)
			if not is_zero_approx(diff):
				unbridled_velocity.y -= diff * WALL_BOOST_MULT
				_wall_boosted = true
				
	wall_jump()

# Other floor stuff
func physics_floor(_delta: float) -> void:
	if is_on_floor():
		if not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
			velocity.x = floor(velocity.x * VELOCITY_GROUND_NERF)				# Nerf x velocity here
			unbridled_velocity.x = flpcen(unbridled_velocity.x * VELOCITY_GROUND_NERF)
		else:
			velocity.x = flpcen(velocity.x * VELOCITY_GROUND_MOVEMENT_NERF)
			#unbridled_velocity.x = floor(unbridled_velocity.x * VELOCITY_GROUND_MOVEMENT_NERF)

# Wall jump
func wall_jump() -> void:
	if (_can_wall_jump and not is_on_floor()) or is_on_wall_only():
		if Input.is_action_just_pressed("jump"):
			unbridled_velocity.y = min(0, unbridled_velocity.y)
			unbridled_velocity += Vector2.from_angle(WALL_JUMP_ANGLE_L if _wall_normal.x < 0 else WALL_JUMP_ANGLE_R) * wall_jump_vel_boost
			_can_wall_jump = false
			
			sprite.flip_h = not sprite.flip_h

# Floor if positive + ceil if negative (flpcen)
func flpcen(value: float) -> float:
	return floor(value) if value > 0 else ceil(value)

# Signal method(s) #

func _on_area_2d_body_entered(_body: Node2D) -> void:
	_can_wall_jump = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if $Area2D.get_overlapping_bodies().is_empty():
		_can_wall_jump = false
