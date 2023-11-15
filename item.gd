extends Area3D

@export var TYPE = "add_jump"

func _on_body_entered(body):
	if body == get_parent().get_node("Player"):
		if TYPE == "add_jump":
			add_jump()
		queue_free()


func add_jump():
	get_parent().get_node("Player").INT_DOUBLE_JUMP += 5
	

