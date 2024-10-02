extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


#Variables





#Signals
signal switch(next_level_key: String, next_level_pos_add: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("switch", Callable(GameManager.current_level_manager, "next"))




func _on_back_pressed() -> void:
	self.visible = false


func _on_tutorial_level_1_pressed() -> void:
	var keys: Array[String]
	var collection: Array[String]
	keys.append("1x1")
	collection.append("base_collection")
	GameManager.current_level_manager.setup_levels(keys, collection)
	
	emit_signal("switch", "1x1", Vector2.ZERO)
	GameManager.current_level_manager.cur_player.position = Vector2(-8, 4) * Level.BASE_TILE_SIZE
	hide()


func _on_tutorial_level_2_pressed() -> void:
	var keys: Array[String]
	var collection: Array[String]
	keys.append("1x2")
	collection.append("base_collection")
	GameManager.current_level_manager.setup_levels(keys, collection)
	
	#level_manager.next("1x2", Vector2.ZERO)
	emit_signal("switch", "1x2", Vector2.ZERO)
	GameManager.current_level_manager.cur_player.position = Vector2(-8, 4) * Level.BASE_TILE_SIZE
	hide()



func _on_tutorial_level_3_pressed() -> void:
	var keys: Array[String]
	var collection: Array[String]
	keys.append("1x3")
	collection.append("base_collection")
	GameManager.current_level_manager.setup_levels(keys, collection)

	emit_signal("switch", "1x3", Vector2.ZERO)
	GameManager.current_level_manager.cur_player.position = Vector2(-8, 4) * Level.BASE_TILE_SIZE
	hide()



func _on_level_1_pressed() -> void:
	var keys: Array[String]
	var collection: Array[String]
	keys.append("1x4")
	collection.append("base_collection")
	GameManager.current_level_manager.setup_levels(keys, collection)
	
	emit_signal("switch", "1x4", Vector2.ZERO)
	GameManager.current_level_manager.cur_player.position = Vector2(-8, 4) * Level.BASE_TILE_SIZE
	hide()


func _on_level_2_pressed() -> void:
	var keys: Array[String]
	var collection: Array[String]
	keys.append("1x5")
	collection.append("base_collection")
	GameManager.current_level_manager.setup_levels(keys, collection)
	
	emit_signal("switch", "1x5", Vector2.ZERO)
	GameManager.current_level_manager.cur_player.position = Vector2(-8, 4) * Level.BASE_TILE_SIZE
	hide()


func _on_level_3_pressed() -> void:
	var keys: Array[String]
	var collection: Array[String]
	keys.append("1x6")
	collection.append("base_collection")
	GameManager.current_level_manager.setup_levels(keys, collection)
	
	emit_signal("switch", "1x6", Vector2.ZERO)
	GameManager.current_level_manager.cur_player.position = Vector2(-8, 4) * Level.BASE_TILE_SIZE
	hide()
