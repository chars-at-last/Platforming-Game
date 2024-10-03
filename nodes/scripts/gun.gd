@icon("res://icon.svg")

class_name Gun extends Node2D


# Constants
const CHARGE_TIME: float = .5							## Charge time for the gun
const GUN_BOOST_MAGNITUDE: float = 800					## Magnitude of the gun knockback

# Variable(s)
@onready var sprite: Sprite2D = $Sprite2D				## Sprite2D
@onready var timer: Timer = $Timer						## Timer
@export var base_node: Player							## The player
@export var camera: Camera2D							## The Camera (usually of the player)

var base_position: Vector2								## Base gun position
var flipped: bool = false								## Whether or not gun is "flipped"

@export var charged_color: Color						## Color when gun is charged
@export var charging_color_start: Color					## Color when gun is charging (start)
@export var charging_color_end: Color					## Color when gun is charging (end)
@export var empty_color: Color							## Color when gun has no charges
@export var shake_amount: float = 4						## Shaking of gun when charging
var gun_color_tween: Tween								## Tween for gun color

var gun_charge_instance

var _charging: bool = false								## Flag if charging gun
var _can_fire: bool = true								## Flag if the gun can charge/fire

# Ready
func _ready() -> void:
	self.base_position = position
	self.change_gun_color(charged_color)
	self.change_gun_shake(0)

# Process
func _physics_process(_delta: float) -> void:
	# LOOK AT ME HECTOR
	self.look_at(get_global_mouse_position() + self.position)
	
	# Gun
	physics_gun_control(_delta)
	
	#print(base_position)
		
# Controls the gun charging
func physics_gun_control(_delta: float) -> void:
	if _can_fire:
		if Input.is_action_just_pressed("charge_gun"):
			_charging = true
			gun_charge_instance = SoundManager.instance_poly("gun", "charging", LevelManager.sfx_bus)
			gun_charge_instance.trigger()
			timer.start(CHARGE_TIME)
			
			# Tween
			if self.gun_color_tween:
				gun_color_tween.kill()
			
			self.gun_color_tween = self.create_tween().set_parallel()
			gun_color_tween.tween_method(change_gun_color, charging_color_start, charging_color_end, CHARGE_TIME)
			gun_color_tween.tween_method(change_gun_shake, 0, shake_amount, CHARGE_TIME)
			
		if _charging and Input.is_action_just_released("charge_gun"):
			_charging = false
			gun_charge_instance.release()
			SoundManager.play("gun", "blast", LevelManager.sfx_bus)
			fire_gun(1.0 - (timer.time_left / CHARGE_TIME))
			timer.stop()
			
			# Tween
			if self.gun_color_tween:
				gun_color_tween.kill()
			change_gun_color(empty_color)
			change_gun_shake(0)
			
	if not _can_fire and base_node.unbridled_velocity.y >= 0 and base_node.is_on_floor():
		change_can_fire(true)
		
# Fires the gun
func fire_gun(percent: float) -> void:
	base_node.unbridled_velocity -= GUN_BOOST_MAGNITUDE * percent * Vector2.from_angle(self.rotation)
	change_can_fire(false)
	
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

# Change if gun can be fired
func change_can_fire(can_fire: bool) -> void:
	_can_fire = can_fire
	change_gun_color(charged_color if can_fire else empty_color)

# Change gun color
func change_gun_color(color: Color) -> void:
	sprite.material.set_shader_parameter("change_color", color)
	
# Change gun shake
func change_gun_shake(amount: float) -> void:
	sprite.material.set_shader_parameter("shake_amount", amount)
