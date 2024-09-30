class_name LevelLoader extends Node2D

# Variables
var thread: Thread					## Thread to process loading on
var mutex: Mutex					## Mutex lock
var loaded_levels: Dictionary		## Dictionary to hold levels (String - PackedScene)
var currently_loading: bool = false	## Whether or not levels are currently loading

# Signals
signal finished_loading

# Ready
func _ready():
	mutex = Mutex.new()
	#thread = Thread.new()
	#thread.start(preload_scenes)

# Loads the levels in the background
func load_levels(keys: Array[String], levels_paths: Array[String], level_keys: Array[String]) -> void:
	#var scene1 = load("res://nodes/scenes/level_temp.tscn")

	currently_loading = true
	thread = Thread.new()
	thread.start(func() -> void:
		mutex.lock()
		var i: int = 0
		for key in keys:
			if key not in loaded_levels:
				loaded_levels[level_keys[i]] = load(levels_paths[i] + key + ".tscn")
			i += 1
		mutex.unlock()
		)
	thread.wait_to_finish()
	currently_loading = false

	# Signal that loading is done
	#print("Scenes preloaded", scene1)
	emit_signal("finished_loading")

# Clears currently loaded level, save exceptions
func clear_levels(exceptions: Array[String] = []) -> void:
	exceptions.filter(func(x: String) -> bool: return not x.is_empty())
	
	thread = Thread.new()
	thread.start(func() -> void:
		mutex.lock()
		for key in loaded_levels:
			if key not in exceptions:
				loaded_levels.erase(key)
		mutex.unlock()
		)
	thread.wait_to_finish()

# Safe way to get the loaded levels
func get_loaded_level(key: String) -> PackedScene:
	if currently_loading:
		await finished_loading
		
	return loaded_levels[key]

func _exit_tree():
	if thread and thread.is_started():
		thread.wait_to_finish()
