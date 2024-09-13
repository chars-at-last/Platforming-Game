class_name Checkpoint extends Tile

@export var checkpoint_level_id: String				##Level id that the checkpoint is in

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	

func handle_collision(collider: Node) -> void:
	if collider is Player:
		print("CheckPoint Reached!", collider.global_position)
		SpawnPoint.global_vector = collider.global_position
		print(checkpoint_level_id)
		SpawnPoint.check_point_level = checkpoint_level_id
		for cell in get_used_cells():
			var tile_id = get_cell_source_id(cell)
			tile_set.set_physics_layer_collision_layer(tile_id, 0)
			tile_set.set_physics_layer_collision_mask(tile_id, 0)
			
