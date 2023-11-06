extends Area3D

var direction = Vector3.RIGHT
var speed = 10

func _physics_process(delta):
	position += direction * speed * delta

func _on_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body == get_parent().get_node("Player"):
		if body.damage_collision:
			body.hit(self)
			queue_free()
	elif !body.is_in_group("enemy"):
		queue_free()
