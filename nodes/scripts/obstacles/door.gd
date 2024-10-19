class_name Door extends Path2D


#Variables
@onready var animation = $AnimationPlayer

@export var id: int


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DoorOpened.can_open:
		animation.play("Movement")
		DoorOpened.can_open = false
		print(DoorOpened.can_open)
