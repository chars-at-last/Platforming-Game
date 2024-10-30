class_name Coin extends Tile


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

# Constant(s)
const RESPAWN_OFFSET: Vector2 = Vector2(.5, 0)

# Variables and signal
@export var total_coins: int
@export var id: int

var door: Door = Door.new()
var animation = door.animation

var distances = []
var cells = []

var can_collide = true

#signal coins_now(num, id)





func _ready() -> void:
	DoorOpened.door_ids[id] = false
	DoorOpened.coins_needed_for_door[id] = total_coins
	#var source = tile_set.get_source(0)
	modulate = Color(id - 1, 1, 0)
	#door._update_num(1, 1)
	#connect("coins_now", Callable(door, "_update_num"))
	#var door: Door = Door.new()
	#connect("collected", Callable(door, "_on_coins_collected"))



func handle_collision(collider: Node) -> void:
	if can_collide:
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
			
			set_cell(cells[index], -1)
			#print("and their perspective distances to player", distances)
			
			#Recycled code from checkpoint, basically, if the player touches a coin, set the coin's atlas 
			#coordinates to an invalid vector (5, 5), removing the coin from the screen
			var offset: Vector2i = Vector2i.ZERO
			#while true:
			var pos: Vector2i = cells[index] + offset
			var coords := get_cell_atlas_coords(pos)
			#print(coords)
			if coords == Vector2i(4, 1) or coords == Vector2i(0, 0):
				set_cell(pos, 1, Vector2i(5, 5))
				#break
			elif coords == Vector2i(4, 2):
				offset.y -= 1
			total_coins -= 1

			distances = []
			cells = []
			#print(total_coins)
			can_collide = false
			DoorOpened.coins_needed_for_door[id] = total_coins
			#emit_signal("coins_now", total_coins, id)
			$Timer.start()
			if total_coins == 0:
				print(id)
				print("id ", DoorOpened.door_ids.size())
				DoorOpened.door_ids[id] = true
				print(DoorOpened.door_ids)


func _on_timer_timeout() -> void:
	can_collide = true
