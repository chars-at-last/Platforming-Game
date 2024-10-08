class_name Spikes extends Tile


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
signal death(body)

# Ready
func _ready() -> void:
	if GameManager.current_level_manager:
		connect("death", Callable(GameManager.current_level_manager, "on_death"))

# Handle collision
func handle_collision(collider: Node) -> void:
	if collider is Player:
		print("Player Died!")
		#body.on_death()
		#on_death(collider)
		emit_signal("death", collider)

#func on_death(body) -> void:
	#body.visible = false
	#body._can_control = false
	
	#await get_tree().create_timer(1).timeout
	#reset_player(body)
	
#func reset_player(body) -> void:
	#body.global_position = SpawnPoint.global_vector
	#body.visible = true
	#body._can_control = true
