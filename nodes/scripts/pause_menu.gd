extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	

#variables
var is_paused: bool = false:
	set = set_paused
	
	
	


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
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused



#Resuming the game
func _on_resume_pressed() -> void:
	is_paused = false


func _on_control_pressed() -> void:
	pass # Replace with function body.


func _on_save_quit_pressed() -> void:
	get_tree().quit()
