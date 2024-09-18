class_name Checkpoint extends Tile

# Constant(s)
const RESPAWN_OFFSET: Vector2 = Vector2(.5, 0)

# Variable(s)
#var checkpoint_level_id: String				##Level id that the checkpoint is in
var distances = []
var cells = []

# Signal(s)
signal checkpoint_reached()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_manager: LevelManager = GameManager.current_level_manager
	connect("checkpoint_reached", Callable(level_manager, "_on_checkpoint_reached"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	

#When the player collide with a checkpoint, this method will update the variables
#in singleton SpawnPoint to reflect the latest player spawnpoint and the level 
#they are in. This will also deactivate the checkpoint
func handle_collision(collider: Node) -> void:
	if collider is Player:
		SpawnPoint.check_point_on = true
		print("CheckPoint Reached!", collider.global_position)
		emit_signal("checkpoint_reached")
		#SpawnPoint.global_vector = spawn_point.global_position
		
		#print(checkpoint_level_id)
		#SpawnPoint.check_point_level = checkpoint_level_id
		for cell in get_used_cells():
		#if cell in get_used_cells():
			var cell_world_position = Level.to_pixel_coords(Vector2(cell))
			#var cell_world_position = map_to_local(cell)
			cells.append(cell)
			print(cell)
			#print("tile position: ", cell_world_position)
			print("player", Level.to_pixel_coords(collider.global_position))
			print("distance to player: ",cell_world_position.distance_to(collider.global_position - Vector2(320, 180)))
			distances.append(cell_world_position.distance_to(Level.to_pixel_coords(local_to_map(collider.global_position - Vector2(320, 180)))))
			#if (cell_world_position.distance_to(collider.global_position) < 200):
			#var tile_id = get_cell_source_id(cell)
			#tile_set.set_physics_layer_collision_layer(tile_id, 0)
			#tile_set.set_physics_layer_collision_mask(tile_id, 0)
		#for cell in get_used_cells():
			#distances.min()
		var index = distances.find(distances.min(), 0)
		print(index)
		
		SpawnPoint.global_vector = Level.to_pixel_coords(Vector2(cells[index]) + RESPAWN_OFFSET)
		distances = []
		cells = []
			#print(SpawnPoint.global_vector)
