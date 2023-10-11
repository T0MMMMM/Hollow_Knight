extends CharacterBody2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

func _physics_process(delta):
	$AnimatedSprite2D.play("stay")
	velocity = direction * 25
	move_and_slide()
	
