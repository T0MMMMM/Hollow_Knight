extends Area3D

@export var x_spike : float
@export var y_spike : float

func _on_body_entered(body):
	if body == get_parent().get_parent().get_node("Player"):
		body.position.x = x_spike
		body.position.y = y_spike
		
