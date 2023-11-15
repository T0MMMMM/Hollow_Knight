extends Area3D


func _on_body_entered(body):
	if body == get_parent().get_parent().get_node("Player"):
		body.position.x = 12
		body.position.y = 4.5
		
