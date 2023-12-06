extends Camera3D
 
@export var lerpspeed = 0.03
 
func _ready():
	position.x = GlobalVariable.player_data.global_position.x
	position.y = GlobalVariable.player_data.global_position.y

func _physics_process(delta):
	position.x = lerp(position.x, get_parent().get_node("Player").position.x, lerpspeed)
	position.y = lerp(position.y, get_parent().get_node("Player").position.y, lerpspeed)

func cam_pos(pos) :
	position.x = pos.x
	position.y = pos.y
