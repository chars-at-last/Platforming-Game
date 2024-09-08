@icon("res://icon.svg")

class_name Level extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.set_cur_level(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
