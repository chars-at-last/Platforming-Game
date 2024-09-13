@icon("res://icon.svg")

class_name Level extends Node2D


# Constant(s)
const BASE_LEVEL_SIZE: Vector2 = Vector2(20, 12)
const BASE_TILE_SIZE: Vector2 = Vector2.ONE * 32
const DEFAULT_SPAWN: Vector2 = Vector2.ZERO

# Variable(s)
@export var size: Vector2 = BASE_LEVEL_SIZE
@export var default_spawn: Vector2 = DEFAULT_SPAWN

@onready var goals: Node = $Goals

# Ready
func _ready() -> void:
	SpawnPoint.original_spawn = default_spawn
	if GameManager.current_level_manager:
		GameManager.current_level_manager.set_cur_level(self)
	
		# Load adjacent levels
		var keys: Array[String]
		var collection: Array[String]
		for goal: Goal in goals.get_children():
			#print("test",goal.current_level_key)
			keys.append(goal.next_level_key)
			collection.append(goal.level_collection_key)
			
		GameManager.current_level_manager.setup_levels(keys, collection)

# Convert from "map" coordinates
static func to_pixel_coords(coords: Vector2) -> Vector2:
	return coords * BASE_TILE_SIZE
	
# Convert to "map" coordinates
static func to_map_coords(coords: Vector2) -> Vector2:
	return coords / BASE_TILE_SIZE

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#LevelManager.set_cur_level(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
