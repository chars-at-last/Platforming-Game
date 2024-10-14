class_name Coin extends Tile


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func handle_collision(collider: Node) -> void:
	if collider is Player:
		print("coin collected!")
