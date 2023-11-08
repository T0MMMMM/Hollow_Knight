extends CharacterBody3D

@onready var ray_cast = $RayCast3D
@onready var player = get_parent().get_node("Player")

var direction = Vector3.RIGHT
var speed = 2.4

func _ready():
	randomize()
	direction = (player.position - global_position).normalized()
	ray_cast.target_position = direction * 10

func _process(delta):
	direction = (player.position - global_position).normalized()
	ray_cast.target_position = direction * 10

var gravity = 15

func _physics_process(delta):
	position.z = 0
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

