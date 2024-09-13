class_name DeathBlock extends Tile


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
	#print(collider.is_in_group("is_able_to_die"))
	#print_debug("Group ", get_tree().has_group("is_able_to_die"))
	if collider.is_in_group("Can_Die"):
	#if collider is Player:
		print("Death Block Touched! DIE!")
		#body.on_death()
		#on_death(collider)
		emit_signal("death", collider)
