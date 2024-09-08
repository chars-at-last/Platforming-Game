extends Node


# Variable(s)
static var _cur_level: Level = null
#static var _cur_checkpoint: Checkpoint = null

# Signal(s)
signal level_set
signal checkpoint_set

# Sets current level
static func set_cur_level(level: Level) -> void:
	_cur_level = level
	LevelManager.emit_signal("level_set", _cur_level)
	
# Gets current level
static func get_cur_level() -> Level:
	if not _cur_level:
		await LevelManager.level_set
	return _cur_level
	
