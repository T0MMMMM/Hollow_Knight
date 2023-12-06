extends Area3D

func _on_body_entered(body):
	if body == get_parent().get_parent().get_node("Player"):
		body.position.x = GlobalVariable.safe_position.x
		body.position.y = GlobalVariable.safe_position.y
		
