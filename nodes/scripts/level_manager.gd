class_name LevelManager extends Node2D


# Constant(s)
const PLAYER_PATH: String = "res://nodes/scenes/player/player.tscn"
const PAUSE_PATH: String = "res://nodes/scenes/pause_menu.tscn"

# Signal(s)
signal level_set
signal checkpoint_set

# Variable(s)
var _cur_packed_level: PackedScene = null
static var cur_level: Level = null
static var cur_checkpoint: Checkpoint = null
static var cur_player: Player = null

#var loading_from_save: bool = false		#Is the player loading from a saved game?
@export var cur_level_key: String = "1x1"

# TODO: Change this default_level later
#@export var default_level: PackedScene = preload("res://nodes/scenes/levels/created levels/level_01.tscn")
@export var default_level: PackedScene = preload("res://nodes/scenes/levels/created levels/tutorial_level.tscn")
@export var level_collection: Dictionary = {"base_collection": preload("res://assets/resources/base_level_collection.tres")}

@onready var level_loader: LevelLoader = $LevelLoader


#@onready var check_point: Checkpoint = $CheckPoint


# Ready
func _ready() -> void:
	if not SoundManager.has_loaded:
		await SoundManager.loaded
	
	GameManager.current_level_manager = self
	# TODO: Allow for any level to be the default
	if SaveManager.level() == SaveManager.level_key:
		add_child(default_level.instantiate())
	else:
		add_child(load(level_collection["base_collection"].levels_path + level_collection["base_collection"].collection[SaveManager.level()] + ".tscn").instantiate())
	
	if not cur_checkpoint:
		#print('!')
		if not cur_player:
			cur_player = load(PLAYER_PATH).instantiate()
		cur_level.add_child(cur_player)
		cur_player.position = Level.to_pixel_coords(cur_level.default_spawn)
		#print('player coords: ', Level.to_pixel_coords(cur_level.default_spawn))
		handle_player_camera()
	#Calling save manager to see if the last saved player location is the 
	#starting level, if not, load the current level that the player is in
	print(SaveManager.level, SaveManager.player)
		#if save.level != "error": #and save.check_point_level() != null and save.check_point_loc() != null:
	
	if SaveManager.level() != SpawnPoint.original_spawn_key: #and SaveManager.level() != null:
		next(SaveManager.level(), SaveManager.player())
		cur_player.position = SaveManager.player()
		print(8)
	elif SaveManager.player() != null:
		print("in first level")
		cur_player.position = SaveManager.player()
		print(9)
		
	if SaveManager.check_point_loc() != null:
		SpawnPoint.global_vector = SaveManager.check_point_loc()
		SpawnPoint.check_point_level = SaveManager.check_point_level()
		print(0)
		
		
	#var instance = load(PAUSE_PATH).instantiate()
	#print("test", instance.position)
	#instance.position = get_viewport().get_camera_2d().global_position
	#add_child(instance)
	#$PauseMenu.global_position = get_viewport().get_camera_2d().global_position
	
	print("camera: ", get_viewport().get_camera_2d().global_position)

# Sets current level
func set_cur_level(level: Level) -> void:
	_cur_packed_level = PackedScene.new()
	_cur_packed_level.pack(level)
	cur_level = level
	emit_signal("level_set", cur_level)
	
# Gets current level
func get_cur_level() -> Level:
	if not cur_level:
		await level_set
	return cur_level

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
		#await get_tree().physics_frame
		cur_level.call_deferred("remove_child", cur_player)									# Save player
		cur_level.queue_free()																	# Remove old level
		#print(level_loader.loaded_levels)
		var next_level: Level = level_loader.loaded_levels[next_level_key].instantiate()		# Get next level
		level_loader.clear_levels([SpawnPoint.check_point_level])								# Clear old loaded levels
		#await get_tree().physics_frame
		add_child(next_level)																	# Add next level
		#self.call_deferred("add_child", next_level)
		
		#If we are loading from a save file, we will spawn the player in some other way
		#if loading_from_save:
			#loading_from_save = false
			#print("loaded")
			#cur_player.set_position(cur_player.position - next_level_pos_add)
		#else:
		cur_player.set_position(cur_player.position + Level.to_pixel_coords(next_level_pos_add))# Change player position
		cur_level.call_deferred("add_child", cur_player)										# Add back player
		print("Switching level complete, player is at ", cur_player.position)
		#print("Intended spawn point ", next_level_pos_add)
		
		handle_player_camera()																	# Handle player camera
	
		cur_level_key = next_level_key															# Update key
		SpawnPoint.spawn_key = cur_level_key
		print(';;', cur_level_key)
	
# Handles the player's camera
func handle_player_camera() -> void:
	# Player Camera stuff
	var level_size = cur_level.size * Level.BASE_TILE_SIZE
	cur_player.camera.set_limit(SIDE_RIGHT, level_size.x)
	cur_player.camera.set_limit(SIDE_BOTTOM, level_size.y)
	#pass
	
func on_death(body) -> void:
	body.visible = false
	body._can_control = false
	
	await get_tree().create_timer(1).timeout
	reset_player(body)
	
func reset_player(body) -> void:
	# Reload level
	#remove_child(cur_level)
	#cur_level.queue_free()
	#add_child(_cur_packed_level.instantiate())
	
	print(SpawnPoint.check_point_on)
	# if the last checkpoint is in a different level, we will change the scene back to the correct level first before spawning the player
	if SpawnPoint.check_point_level == cur_level_key:
		print("Spawning in current level", cur_level_key)
		#print(SpawnPoint.global_vector)
		
		# Reload current level
		#remove_child(cur_level)
		#cur_level.queue_free()
		#add_child(_cur_packed_level.instantiate())
		next(cur_level_key, Vector2.ZERO)
		body.position = SpawnPoint.global_vector
	elif !SpawnPoint.check_point_on and SaveManager.check_point_level() == null:
		print("No checkpoint, restarting game")
		
		
		#In case if we died in another level after we used the level_select, 
		#re-setup the starting level so we can spawn the player at the beginning
		var keys: Array[String]
		var collection: Array[String]
		keys.append("1x1")
		collection.append("base_collection")
		setup_levels(keys, collection)
		
		next(SpawnPoint.original_spawn_key, Level.to_pixel_coords(Vector2.ZERO))
		#print(Level.to_pixel_coords(cur_level.default_spawn))
		cur_player.position = Level.to_pixel_coords(cur_level.default_spawn)
	else:
		print("Last checkpoint in previous level, switching level")
		next(SpawnPoint.check_point_level, Vector2.ZERO)#SpawnPoint.global_vector)
		cur_player.position = SpawnPoint.global_vector
		print("Spawning player ", SpawnPoint.global_vector)
		
	#body.velocity = Vector2.ZERO
	#body.unbridled_velocity = Vector2.ZERO
	body.reset()

# Signal method(s) #

func _on_goal_tile_complete_level(next_level_key: String, next_level_pos_add: Vector2) -> void:
	if cur_level_key != next_level_key:
		next(next_level_key, next_level_pos_add)
		
func _on_checkpoint_reached() -> void:
	SpawnPoint.check_point_level = cur_level_key
	
	print('::', cur_level_key)
	print(':', SpawnPoint.check_point_level)
