extends Camera3D
 
@export var lerpspeed = 0.03
 
func _ready():
	pass

func _physics_process(delta):
	position.x = lerp(position.x, get_parent().get_node("Player").position.x, lerpspeed)
	position.y = lerp(position.y, get_parent().get_node("Player").position.y, lerpspeed)
