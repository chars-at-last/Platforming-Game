class_name LevelManager extends Node2D


# Constant(s)
const PLAYER_PATH: String = "res://nodes/scenes/player/player.tscn"

# Signal(s)
signal level_set
signal checkpoint_set

# Variable(s)
static var _cur_level: Level = null
static var cur_checkpoint: Checkpoint = null
static var cur_player: Player = null

var cur_level_key: String = "1x1"

# TODO: Change this default_level later
@export var default_level: PackedScene = preload("res://nodes/scenes/levels/created levels/level_01.tscn")
@export var level_collection: Dictionary = {"base_collection": preload("res://assets/resources/base_level_collection.tres")}

@onready var level_loader: LevelLoader = $LevelLoader


#@onready var check_point: Checkpoint = $CheckPoint


# Ready
func _ready() -> void:
	GameManager.current_level_manager = self
	# TODO: Allow for any level to be the default
	add_child(default_level.instantiate())
	
	# TODO: Allow for the current checkpoint to be loaded from a save file
	if not cur_checkpoint:
		if not cur_player:
			cur_player = load(PLAYER_PATH).instantiate()
		_cur_level.add_child(cur_player)
		cur_player.position = Level.to_pixel_coords(_cur_level.default_spawn)

# Sets current level
func set_cur_level(level: Level) -> void:
	_cur_level = level
	emit_signal("level_set", _cur_level)
	
# Gets current level
func get_cur_level() -> Level:
	if not _cur_level:
		await level_set
	return _cur_level

# Setup upcoming levels
func setup_levels(level_keys: Array[String], level_collection: Array[String]) -> void:
	var true_level_names: Array[String]
	var levels_path: Array[String]
	for i in range(0, level_keys.size()):		
		true_level_names.append(self.level_collection[level_collection[i]].collection[level_keys[i]])
		levels_path.append(self.level_collection[level_collection[i]].levels_path)
		
	level_loader.load_levels(true_level_names, levels_path, level_keys)

#func level_loaded(instance1):
	#add_child(instance1)
	#next_level = instance1.get_path()

#func _on_goal_tile_complete_level() -> void:
func next(next_level_key: String, next_level_pos_add: Vector2) -> void:
	print("Switching level ", next_level_key)
	#print(SpawnPoint.check_point_level)
	#get_tree().call_deferred("change_scene_to_file", "res://nodes/scenes/level.tscn")
	#var scene = $instance
	#get_tree().call_deferred("change_scene_to_file", next_level)
	
	if level_loader.loaded_levels.has(next_level_key):
		_cur_level.call_deferred("remove_child", cur_player)									# Save player
		_cur_level.queue_free()																	# Remove old level
		#print(level_loader.loaded_levels)
		var next_level: Level = level_loader.loaded_levels[next_level_key].instantiate()		# Get next level
		level_loader.clear_levels()																# Clear old loaded levels
		add_child(next_level)																	# Add next level
		
		_cur_level.call_deferred("add_child", cur_player)										# Add back player
		#cur_player.position += Level.to_pixel_coords(next_level_pos_add)						# Change player position
		cur_player.position = next_level_pos_add
		print("Switching level complete, player is at ", cur_player.position)
		print("Intended spawn point ", next_level_pos_add)
	
func on_death(body) -> void:
	body.visible = false
	body._can_control = false
	
	await get_tree().create_timer(1).timeout
	reset_player(body)
	
func reset_player(body) -> void:
	print(SpawnPoint.check_point_on)
	# if the last checkpoint is in a different level, we will change the scene back to the correct level first before spawning the player
	if SpawnPoint.check_point_level == cur_level_key:
		print("Spawning in current level", cur_level_key)
		body.position = Level.to_pixel_coords(SpawnPoint.global_vector)
	elif !SpawnPoint.check_point_on:
		print("No checkpoint, restarting game")
		next(SpawnPoint.original_spawn_key, Level.to_pixel_coords(SpawnPoint.original_spawn))
	else:
		print("Last checkpoint in previous level, switching level")
		next(SpawnPoint.check_point_level, Vector2(20, 0))#SpawnPoint.global_vector)
		print("Spawning player ", SpawnPoint.global_vector)
	body.visible = true
	body._can_control = true
	body.velocity = Vector2.ZERO
	body.unbridled_velocity = Vector2.ZERO

func _on_goal_tile_complete_level(next_level_key: String, next_level_pos_add: Vector2) -> void:
	next(next_level_key, next_level_pos_add)
	cur_level_key = next_level_key
