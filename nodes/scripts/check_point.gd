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
		
		
		#Get the position of the cell, store the position into an array 
		#called cells, then get the distance of the cell from player and store
		#the distance into the array called distances. We will then find the min
		#distance, the cell with the minimum distance to the player will be the
		#checkpoint that the player will spawn in, since it will be the last 
		#checkpoint the player touched. We will reset the arrays at the end so
		#the player can touch and respawn at the other checkpoints without issue.
		#Note: all print statements are used for testing
		for cell in get_used_cells():
			var cell_world_position = Level.to_pixel_coords(Vector2(cell))
			
			#Change all the checkpoint tile without the signs into the tile that has the sign
			if get_cell_atlas_coords(cell) == Vector2i(3, 1):
				set_cell(cell, 1, Vector2i(4, 1))
			
			cells.append(cell)
			print("distance to player: ",cell_world_position.distance_to(local_to_map(collider.global_position - Vector2(320, 180))))
			#print("distance to player: ",cell_world_position.distance_to(collider.global_position - Vector2(640, 360)))
			distances.append(cell_world_position.distance_to(Level.to_pixel_coords(local_to_map(collider.global_position - Vector2(320, 180)))))
		var index = distances.find(distances.min(), 0)
		
		#print("all cells ", cells)
		#print("and their perspective distances to player", distances)
		
		SpawnPoint.global_vector = Level.to_pixel_coords(Vector2(cells[index]) + RESPAWN_OFFSET)
		print(get_cell_atlas_coords(cells[index]))
		
		#If the checkpoint has the sign on it, we switch the tile to the one without the sign
		if get_cell_atlas_coords(cells[index]) == Vector2i(4, 1):
			#print()
			set_cell(cells[index], 1, Vector2i(3, 1))

		distances = []
		cells = []
		print(SpawnPoint.global_vector)
