class_name Door extends Path2D


#Variables
@onready var animation = $AnimationPlayer
@onready var coins_needed = $AnimatableBody2D/Label
@onready var door = $AnimatableBody2D/TileMapLayer

@export var id: int



# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
	
	

# Since we plan for some levels to have multiple doors, the doors
#will each have their own unique ids, so the ids and whether they can
#open (true or false) are stored in a dictionary in DoorOpened, if the 
#id correspond to true, we open the door by playing the animation
func _process(delta: float) -> void:
	if DoorOpened.coins_needed_for_door[id] != 0:
		coins_needed.text = str(DoorOpened.coins_needed_for_door[id])
		coins_needed.set("theme_override_colors/font_color", Color(id - 1, 1, 0))
	else:
		coins_needed.text = str(" ")
	#print("id of door ", id)
	#print(DoorOpened.door_ids)
	if id - 1 < DoorOpened.door_ids.size() and DoorOpened.door_ids[id]:
		animation.play("Movement")
		var index = 0
		for cell in door.get_used_cells():
			
			print(cell)
			if index == 1:
				door.set_cell(cell, 0, Vector2i(4, 0))
			index += 1
		DoorOpened.door_ids[id] = false
		print(DoorOpened.can_open)
