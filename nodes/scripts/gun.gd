@icon("res://icon.svg")

class_name Gun extends Node2D


# Constants
const CHARGE_TIME: float = .5							## Charge time for the gun
const GUN_BOOST_MAGNITUDE: float = 800					## Magnitude of the gun knockback

# Variable(s)
@onready var timer: Timer = $Timer						## Timer
@export var base_node: Player							## The player

var _charging: bool = false								## Flag if charging gun
var _can_fire: bool = true								## Flag if the gun can charge/fire

# Process
func _physics_process(_delta: float) -> void:
	# LOOK AT ME HECTOR
	self.look_at(get_viewport().get_mouse_position())
	
	# Gun
	physics_gun_control(_delta)
		
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
