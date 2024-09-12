extends Node2D

var thread: Thread

signal finished_loading

func _ready():
	thread = Thread.new()
	thread.start(preload_scenes)


func preload_scenes():
	# Preloading levels
	#var scene1 = ResourceLoader.load("res://nodes/scenes/level.tscn")
	var scene1 = load("res://nodes/scenes/level.tscn")
	#var instance1 = scene1.instantiate()

	# Add the instances to the scene tree if needed
	# get_tree().root.add_child(instance1)
	# get_tree().root.add_child(instance2)

	# Signal that preloading is done
	print("Scenes preloaded", scene1)
	emit_signal("finished_loading", scene1)

func _exit_tree():
	thread.wait_to_finish()
