extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	var camera = CurrentCameraZoom.camera_zoom_level
	print("current camera zoom level for help screen ", camera)
	$GridContainer.get_parent().scale = Vector2(1 / camera.x, 1 / camera.y)
	if camera.y < 0.8:
		$GridContainer.get_parent().position += Vector2(0, 200)
	if camera.y == 0.8:
		$GridContainer.get_parent().position += Vector2(0, 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	visible = false
