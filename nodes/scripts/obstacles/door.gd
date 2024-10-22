class_name Door extends Path2D


#Variables
@onready var animation = $AnimationPlayer

@export var id: int


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Since we plan for some levels to have multiple doors, the doors
#will each have their own unique ids, so the ids and whether they can
#open (true or false) are stored in a dictionary in DoorOpened, if the 
#id correspond to true, we open the door by playing the animation
func _process(delta: float) -> void:
	#print("id of door ", id)
	#print(DoorOpened.door_ids)
	if id - 1 < DoorOpened.door_ids.size() and DoorOpened.door_ids[id]:
		animation.play("Movement")
		DoorOpened.door_ids[id] = false
		print(DoorOpened.can_open)
