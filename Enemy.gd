extends CharacterBody2D

@export var LIFE = 500
var direction = Vector2.RIGHT

func _physics_process(delta):
	if LIFE <= 0:
		queue_free()


func take_damage():
	$Sprite2D.texture = ResourceLoader.load("res://donjon_damage.png")
	LIFE -= 10
	$Timer.start()


func _on_timer_timeout():
	$Sprite2D.texture = ResourceLoader.load("res://donjon.png")
