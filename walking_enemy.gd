extends CharacterBody2D

var direction = Vector2.RIGHT

func _physics_process(delta):
	$AnimatedSprite2D.play("stay")
	var found_wall = is_on_wall()
	if found_wall:
		direction *= -1
	
	velocity = direction * 25
	move_and_slide()
	
