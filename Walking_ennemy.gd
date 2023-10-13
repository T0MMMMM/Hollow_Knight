extends CharacterBody2D

@export var LIFE = 500
@export var gravity = 575
@export var knockback_velocity = Vector2(100, -80)
var direction = 1
var hit = false


func _physics_process(delta):
	var found_wall = is_on_wall()
	if found_wall:
		direction *= -1
	
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x =  100
		if GlobalVariable.player_dir:
			velocity.x *= -1
		else:
			velocity.x *= 1
	else:
		velocity.x = direction * 35
		
	if LIFE <= 0:
		queue_free()
	if hit:
		velocity = knockback_velocity
		if GlobalVariable.player_dir:
			velocity.x *= -1
		else:
			velocity.x *= 1
	
	move_and_slide()


func take_damage():
	$Sprite2D.texture = ResourceLoader.load("res://donjon_damage.png")
	LIFE -= 10
	hit = true
	$Timer.start()


func _on_timer_timeout():
	$Sprite2D.texture = ResourceLoader.load("res://donjon.png")
	hit = false
