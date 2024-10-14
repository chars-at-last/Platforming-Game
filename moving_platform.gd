extends Path2D


@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

# If the platform is not moving in a closed path (i.e. the platform is moving up and down
# or left to right), have the AnimationPlayer play the looping animation so the platform will
# return to the starting point before moving on its path again. 
func _ready() -> void:
	if not loop:
		print("something")
		if animation.is_playing():
			await animation.animation_finished
		animation.play("Movement")
		animation.speed_scale = speed_scale
		set_process(false)


# If the platform is moving in a closed path (i.e. moving in a circular path),
# simply have the platform move at the standard speed set for it
func _process(delta: float) -> void:
	path.progress += speed
