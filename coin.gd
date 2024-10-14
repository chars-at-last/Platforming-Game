class_name Coin extends Tile


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

# Constant(s)
const RESPAWN_OFFSET: Vector2 = Vector2(.5, 0)

# Variables
var distances = []
var cells = []

func handle_collision(collider: Node) -> void:
	if collider is Player:
		for cell in get_used_cells():
			var cell_world_position = Level.to_pixel_coords(Vector2(cell))
			
			#Change all the checkpoint tile without the signs into the tile that has the sign
			if get_cell_atlas_coords(cell) == Vector2i(3, 1):
				set_cell(cell, 1, Vector2i(4, 1))
			
			cells.append(cell)
			print("distance to player: ",cell_world_position.distance_to(local_to_map(collider.global_position - Vector2(320, 180))))
			#print("distance to player: ",cell_world_position.distance_to(collider.global_position - Vector2(640, 360)))
			distances.append(cell_world_position.distance_to(Level.to_pixel_coords(local_to_map(collider.position))))
		var index = distances.find(distances.min(), 0)
		
		#print("all cells ", cells)
		#print("and their perspective distances to player", distances)
		
		#If the checkpoint has the sign on it, we switch the tile to the one without the sign
		var offset: Vector2i = Vector2i.ZERO
		#while true:
		var pos: Vector2i = cells[index] + offset
		var coords := get_cell_atlas_coords(pos)
		print(coords)
		if coords == Vector2i(4, 1) or coords == Vector2i(0, 0):
			set_cell(pos, 1, Vector2i(3, 1))
			#break
		elif coords == Vector2i(4, 2):
			offset.y -= 1
		#SpawnPoint.global_vector = Level.to_pixel_coords((Vector2(cells[index]) + RESPAWN_OFFSET))
		#print(get_cell_atlas_coords(cells[index]))

		distances = []
		cells = []
