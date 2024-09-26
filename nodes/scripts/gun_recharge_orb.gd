extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("gun recharged!")
		body.gun.change_can_fire(true)
		visible = false
		set_collision_mask_value(1, false)
		timer.start()


func _on_timer_timeout() -> void:
	print("reenabled!")
	visible = true
	set_collision_mask_value(1, true)
	timer.stop()
