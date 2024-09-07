extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

	


func _on_body_entered(body):
	if body is Player:
		print("Player Died!")
		#body.on_death()
		on_death(body)

func on_death(body) -> void:
	body.visible = false
	body._can_control = false
	
	await get_tree().create_timer(1).timeout
	reset_player(body)
	
func reset_player(body) -> void:
	body.global_position = Vector2(110, 43)
	body.visible = true
	body._can_control = true
