class_name Goal extends Tile

# Signal(s)
signal complete_level(next_level_key: String, next_level_pos_add: Vector2)

# Variable(s)
@export var next_level_key: String									## Key of next level
@export var level_collection_key: String = "base_collection"		## Key of next level collection
@export var current_level_key: String		## Key of current level

@export var next_level_position_add: Vector2						## How to add to player position in transition to next level

var goal_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.current_level_manager:
		connect("complete_level", Callable(GameManager.current_level_manager, "_on_goal_tile_complete_level"))
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func handle_collision(collider: Node) -> void:
	if goal_active and collider is Player:
		print("Level Completed!", next_level_position_add)
		emit_signal("complete_level", next_level_key, next_level_position_add)

func _on_timer_timeout() -> void:
	goal_active = true
