class_name goal extends Tile

signal complete_level()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect("complete_level", Callable(GameManager.current_level_manager, "next"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func handle_collision(collider: Node) -> void:
	if collider is Player:
		print("Level Completed!")
		emit_signal("complete_level")
