extends Node2D


# Variable(s)
static var _cur_level: Level = null
#static var _cur_checkpoint: Checkpoint = null

# Signal(s)
signal level_set
signal checkpoint_set

# Sets current level
func set_cur_level(level: Level) -> void:
	_cur_level = level
	emit_signal("level_set", _cur_level)
	
# Gets current level
func get_cur_level() -> Level:
	if not _cur_level:
		await level_set
	return _cur_level
	

func _ready() -> void:
	#print("Hello")
	GameManager.current_level_manager = self
	#$"/root/LevelManager".connect("complete_level", next)
	#$GoalTile.connect("complete_level", next)

#func _on_goal_tile_complete_level() -> void:
func next() -> void:
	print("Switching level")
	print(SpawnPoint.check_point_level)
	get_tree().call_deferred("change_scene_to_file", "res://nodes/scenes/level.tscn")

func on_death(body) -> void:
	body.visible = false
	body._can_control = false
	
	await get_tree().create_timer(1).timeout
	reset_player(body)
	
func reset_player(body) -> void:
	body.global_position = SpawnPoint.global_vector
	body.visible = true
	body._can_control = true



func back() -> void:
	print("Switching level")
	print(SpawnPoint.check_point_level)
	get_tree().change_scene_to_file("res://nodes/scenes/game_manager.tscn")


func _on_goal_tile_complete_level() -> void:
	#pass # Replace with function body.
	next()
