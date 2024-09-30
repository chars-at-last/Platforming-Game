extends Area2D


# Constant(s)
const ACTIVE_FRAME: int = 0
const INACTIVE_FRAME: int = 1

# Variables
@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("gun recharged!")
		body.gun.change_can_fire(true)
		#visible = false
		sprite.frame = INACTIVE_FRAME
		set_collision_mask_value(1, false)
		timer.start()


func _on_timer_timeout() -> void:
	print("reenabled!")
	#visible = true
	sprite.frame = ACTIVE_FRAME
	set_collision_mask_value(1, true)
	timer.stop()
