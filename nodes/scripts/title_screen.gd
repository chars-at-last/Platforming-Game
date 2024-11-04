class_name TitleScreen extends Control

# Variables
@onready var tab_con: TabContainer = $TabContainer
@onready var color_rect_top: ColorRect = $ColorRectTop
@onready var confirm_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var accept_dialog: AcceptDialog = $AcceptDialog
@onready var accept_dialog2: AcceptDialog = $AcceptDialog2

@export var level_manager: PackedScene
@export var darkness_time: float = 1.75
@export var transition_time: float = 2

# Signals
signal transition_complete

# Transition
func transition() -> void:
	await get_tree().create_tween().tween_property(color_rect_top, "color:a", 1.0, darkness_time).finished
	await get_tree().create_timer(transition_time - darkness_time).timeout
	emit_signal("transition_complete")

# Signal methods #

func _on_button_3_pressed() -> void:
	tab_con.current_tab = 1

func _on_button_pressed() -> void:
	tab_con.current_tab = 0

func _on_button_4_pressed() -> void:
	transition()
	await self.transition_complete
	get_tree().quit()
	
func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _on_button_2_pressed() -> void:
	confirm_dialog.show()

func _on_confirmation_dialog_confirmed() -> void:
	confirm_dialog.hide()
	if SaveManager.delete_save():
		accept_dialog.show()
	else:
		accept_dialog2.show()

func _on_confirmation_dialog_canceled() -> void:
	confirm_dialog.hide()

func _on_button_pressed_title() -> void:
	transition()
	await self.transition_complete
	get_tree().change_scene_to_packed(level_manager)
