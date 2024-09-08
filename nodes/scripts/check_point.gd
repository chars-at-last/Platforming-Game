class_name Checkpoint extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	

#func handle_collision(collider: Node) -> void:
	#if collider is Player:
		#print("CheckPoint Reached!")
		#body.on_death()
		#SpawnPoint.global_vector = collider.global_position


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("CheckPoint Reached!")
		SpawnPoint.global_vector = body.global_position
		$CollisionShape2D.call_deferred("set_disabled", true)
