extends Node


# Variable(s)
static var _cur_level: Level = null

# Sets current level
static func set_cur_level(level: Level) -> void:
	_cur_level = level
	GameManager.emit_signal("level_set", _cur_level)
	
# Gets current level
static func get_cur_level() -> Level:
	if not _cur_level:
		await GameManager.level_set
	return _cur_level
	
