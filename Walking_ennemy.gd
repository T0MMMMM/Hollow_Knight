extends CharacterBody2D

@export var LIFE = 50
var direction = Vector2.RIGHT


func _physics_process(delta):
	var found_wall = is_on_wall()
	if found_wall:
		direction *= -1
	
	velocity = direction * 25
	if LIFE <= 0:
		queue_free()
	move_and_slide()


func take_damage():
	$Sprite2D.texture = ResourceLoader.load("res://donjon_damage.png")
	LIFE -= 10
	$Timer.start()


func _on_timer_timeout():
	$Sprite2D.texture = ResourceLoader.load("res://donjon.png")
