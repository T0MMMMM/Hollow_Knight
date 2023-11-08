extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 14.5
const JUMP_RELEASED_FORCE = 6.0
const JUMP_FORCE = 22.0
@export var DOUBLE_JUMP = 1
var FRICTION = 100
var climb = true
var fell = false
var gravity = 52
var life = 100
var damage_collision = true
@onready var ray_cast_left = $raycast_left
@onready var ray_cast_right = $raycast_right
func _process(delta):
	$life.text = str(life)

func _physics_process(delta):
	
	# Add the gravity
	apply_gravity(delta)
	
	# Mouvement
	var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.x:
		velocity.x = move_toward(velocity.x, SPEED * direction.x, 10)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	# Handle Jump
	jump(direction, delta)
	
	move_and_slide()
	
	# COLLISION
	if damage_collision: check_collision()

func check_collision():
	for index in get_slide_collision_count():
			var collision = get_slide_collision(index)
			if collision.get_collider().is_in_group("enemy"):# || collision.get_collider().is_in_group("tears"):
				hit(collision.get_collider())
				collision.get_collider().move_and_collide(velocity)

func hit(mob):
	life -= 10
	velocity.y += 10
	velocity.x += 60 * mob.direction.x
	damage_collision = false
	$no_collision.start()

func apply_gravity(delta):
	position.z = 0
	if not is_on_floor():
		FRICTION = 0.4
		velocity.y -= gravity * delta
		velocity.y = min(velocity.y, 250)
	else:
		FRICTION = 100

func jump(direction, delta):
	
	if is_on_floor():
		climb = false
		DOUBLE_JUMP = 1
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
		return
	
	if velocity.y < 0:
		climb = true
	
	# Handle Wall Jump / climb
	if climb : 
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding():
			#velocity.y = -5
			DOUBLE_JUMP = 1
			if Input.is_action_just_pressed("jump") && ray_cast_right.is_colliding():
				print("droite")
				velocity.y = JUMP_FORCE
				velocity.x = -18
			
			if Input.is_action_just_pressed("jump") && ray_cast_left.is_colliding():
				print("gauche")
				velocity.y = JUMP_FORCE
				velocity.x = 18
	
	# Handle Double Jump
	if Input.is_action_just_released("jump") and velocity.y > JUMP_RELEASED_FORCE:
		velocity.y = JUMP_RELEASED_FORCE
	
	if Input.is_action_just_pressed("jump") and DOUBLE_JUMP > 0:
		velocity.y = JUMP_FORCE
		DOUBLE_JUMP -= 1
	

func _on_no_collision_timeout():
	damage_collision = true
