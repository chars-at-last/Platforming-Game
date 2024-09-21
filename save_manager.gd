class_name Save_Manager extends Node2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
	
	

var path = "res://saves/player_saves.json"

#Save the level key and the player location
func save(level, player_loc):
	var save_data = {
		"level": level,
		"player_location": player_loc
	}
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	
#Return the saved level key
func level():
	var read = FileAccess.open(path, FileAccess.READ)
	var data = read.get_as_text()
	read.close()
	
	var output = JSON.parse_string(data)
	print(output.level)
	return output.level


#Return the saved player location
func player() -> Vector2:
	var read = FileAccess.open(path, FileAccess.READ)
	var data = read.get_as_text()
	read.close()
	
	var output = JSON.parse_string(data)
	print(output.player_location)
	return str_to_var("Vector2" + output.player_location)
