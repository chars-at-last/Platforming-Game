extends Node


# Handles a tile, returns true if there was a custom behaviour
func handle_tile(tile_data: TileData, collider: Node) -> bool:
	if not tile_data:
		return false
	else:
		var sound_path: String = tile_data.get_custom_data("sound_path")
		if sound_path:
			print("!")		## TODO: add sound effect for walking
			
		var behaviour: TileBase = tile_data.get_custom_data("tile_base")
		if behaviour:
			behaviour.handle_interaction(collider)
			
		return true
