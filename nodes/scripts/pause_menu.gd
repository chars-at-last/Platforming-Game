extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	

#variables
var is_paused: bool = false:
	set = set_paused


@onready var help_scene = preload("res://nodes/scenes/help.tscn")
#var saving = Save_Manager.new()
#var level_manager = LevelManager.new()


#hide the pause menu on start up
func _ready() -> void:
	hide()
	#pass # Replace with function body.


#If the player pressed the pause key
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		is_paused = !is_paused



#Pausing the game
func set_paused(value: bool) -> void:
	var camera = CurrentCameraZoom.camera_zoom_level
	print("Camera zoom level ", CurrentCameraZoom.camera_zoom_level)
	$GridContainer.get_parent().scale = Vector2(1 / camera.x, 1 / camera.y)
	self.global_position = get_parent().get_screen_center_position()
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused



#Resuming the game
func _on_resume_pressed() -> void:
	is_paused = false


func _on_control_pressed() -> void:
	print("Button pressed")
	var help_screen = help_scene.instantiate()
	get_tree().root.add_child(help_screen)
	help_screen.visible = true


func _on_save_quit_pressed() -> void:
	print("Saving this location to the save manager ", GameManager.current_level_manager.cur_player.position)
	SaveManager.save(GameManager.current_level_manager.cur_level_key, GameManager.current_level_manager.cur_player.position, SpawnPoint.check_point_level, SpawnPoint.global_vector, false)
	get_tree().quit()
