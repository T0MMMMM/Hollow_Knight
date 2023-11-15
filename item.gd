extends Area3D

@export var TYPE = "add_jump"

func _on_body_entered(body):
	if body == get_parent().get_node("Player"):
		if TYPE == "add_jump":
			add_jump()
		if TYPE == "add_dash":
			add_dash()
		if TYPE == "add_wall_jump":
			add_wall_jump()
		queue_free()


func add_jump():
	get_parent().get_node("Player").INT_DOUBLE_JUMP += 5
	
func add_dash():
	get_parent().get_node("Player").enable_dash = true
	
func add_wall_jump():
	get_parent().get_node("Player").enable_wall_jump = true
	

