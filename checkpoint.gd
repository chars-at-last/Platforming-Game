extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

var global_vector = Vector2(110, 43)

#var updated_spawn

func _on_body_entered(body):
	if body is Player:
		print("Checkpoint Reached, Spawn Point Updated!")
		SpawnPosition.global_vector = body.global_position
		
