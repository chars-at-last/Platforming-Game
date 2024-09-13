@icon("res://icon.svg")

class_name Gun extends Node2D


# Constants
const CHARGE_TIME: float = .5							## Charge time for the gun
const GUN_BOOST_MAGNITUDE: float = 800					## Magnitude of the gun knockback

# Variable(s)
@onready var sprite: Sprite2D = $Sprite2D				## Sprite2D
@onready var timer: Timer = $Timer						## Timer
@export var base_node: Player							## The player

var base_position: Vector2								## Base gun position
var flipped: bool = false								## Whether or not gun is "flipped"

var _charging: bool = false								## Flag if charging gun
var _can_fire: bool = true								## Flag if the gun can charge/fire

# Ready
func _ready() -> void:
	self.base_position = position

# Process
func _physics_process(_delta: float) -> void:
	# LOOK AT ME HECTOR
	self.look_at(get_viewport().get_mouse_position() + self.position)
	
	# Gun
	physics_gun_control(_delta)
	
	#print(base_position)
		
# Controls the gun charging
func physics_gun_control(_delta: float) -> void:
	if _can_fire:
		if Input.is_action_just_pressed("charge_gun"):
			_charging = true
			timer.start(CHARGE_TIME)
			
		if _charging and Input.is_action_just_released("charge_gun"):
			_charging = false
			fire_gun(1.0 - (timer.time_left / CHARGE_TIME))
			timer.stop()
			
	if not _can_fire and base_node.is_on_floor():
		_can_fire = true
		
# Fires the gun
func fire_gun(percent: float) -> void:
	base_node.unbridled_velocity -= GUN_BOOST_MAGNITUDE * percent * Vector2.from_angle(self.rotation)
	_can_fire = false
	
# Updates base position
func update_base_position(new_base: Vector2, change_position: bool = false) -> void:
	self.base_position = new_base
	if change_position:
		update_position()
		
# Update position
func update_position() -> void:
	self.position = base_position * (Vector2.RIGHT if flipped else Vector2.LEFT) + Vector2.DOWN * base_position
		
# "Flip" gun
func flip(is_flipped: bool) -> void:
	flipped = is_flipped
	update_position()
