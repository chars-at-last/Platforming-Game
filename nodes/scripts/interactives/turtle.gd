class_name Turtle extends Interactive


# Constant(s)
const TURTLE_SPEED: float = 20

# Variable(s)
@onready var sprite: Sprite2D = $Sprite2D

@export var facing_dir: float = 1
var ground_vel: Vector2


func _ready() -> void:
	ground_vel.x = TURTLE_SPEED * facing_dir

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_on_floor():
		velocity = ground_vel
	else:
		velocity.x = 0
		
	if is_on_wall():
		facing_dir = get_wall_normal().x
		ground_vel.x = abs(ground_vel.x) * facing_dir
		sprite.flip_h = facing_dir < 0
