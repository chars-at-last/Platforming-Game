class_name Save_Manager extends Node2D

const level_key: String = "1x1"
const player_location: Vector2 = Vector2(-8, 4) * Level.BASE_TILE_SIZE
#const check_point_lev = "1x1"
#constcheck

var path = "user://player_saves.json"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	var read = FileAccess.open(path, FileAccess.READ)
	print("hello")
	if read == null:
		save(level_key, player_location, null, null)
		print('save created')
	else:
		print('save exists')
		
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
#Save the level key and the player location
func save(level, player_loc, check_point_level, check_point_loc):
	var save_data = {
		"level": level,
		"player_location": player_loc,
		"check_point_level": check_point_level,
		"check_point_loc": check_point_loc
	}
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	

#func save_check_point(check_point_level, check_point_loc):
	#var save_data = {
		#"check_point_level": check_point_level,
		#"check_point_loc": check_point_loc
	#}
	#print("saved!!!!")
	#var save_file = FileAccess.open(path, FileAccess.WRITE)
	#save_file.store_line(JSON.stringify(save_data))
	
#Return the saved level key
func level():
	var read = FileAccess.open(path, FileAccess.READ)
	if read != null:
		var data = read.get_as_text()
		read.close()
		
		var output = JSON.parse_string(data)
		print(output.level)
		return output.level


#Return the saved player location
func player():
	var read = FileAccess.open(path, FileAccess.READ)
	if read != null:
		print("returning player")
		var data = read.get_as_text()
		read.close()
		
		var output = JSON.parse_string(data)
		if output.player_location != null:
			print(output.player_location)
			return str_to_var("Vector2" + output.player_location)
			


#Return the level key of the last checkpoint the player touched 
func check_point_level():
	var read = FileAccess.open(path, FileAccess.READ)
	if read != null:
		var data = read.get_as_text()
		read.close()
		
		var output = JSON.parse_string(data)
		print(output.check_point_level)
		return output.check_point_level



#Return the location of the last checkpoint the player touched 
func check_point_loc():
	var read = FileAccess.open(path, FileAccess.READ)
	if read != null:
		var data = read.get_as_text()
		read.close()
		
		var output = JSON.parse_string(data)
		print(output.check_point_loc)
		if output.check_point_loc != null:
			return str_to_var("Vector2" + output.check_point_loc)
		else:
			return null
