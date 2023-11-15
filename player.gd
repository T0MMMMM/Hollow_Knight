extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 14.5
const JUMP_RELEASED_FORCE = 6.0
const JUMP_FORCE = 22.0
@export var INT_DOUBLE_JUMP = 3
var DOUBLE_JUMP = INT_DOUBLE_JUMP
var FRICTION = 100
var climb = true
var fell = false
var gravity = 52
var life = 100
var damage_collision = true
var last_position_on_ground
var block_input = "None"
var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
var coord = position

var wall_left = false
var wall_right = false
var wall_jump = false

@onready var ray_cast_left = $raycast_left
@onready var ray_cast_right = $raycast_right


func _process(delta):
	$life.text = str(life)
	$coord.text = str(coord)

func _physics_process(delta):
	
	# Add the gravity
	apply_gravity(delta)
	
	# Mouvement
	if block_input == "None":
		input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	if block_input == "Right":
		input_dir = Input.get_vector("move_left", "", "ui_up", "ui_down")
	if block_input == "Left":
		input_dir = Input.get_vector("", "move_right", "ui_up", "ui_down")
		
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
	coord = position
	position.z = 0
	if not is_on_floor():
		FRICTION = 0.1
		velocity.y -= gravity * delta
		velocity.y = min(velocity.y, 250)
	else:
		FRICTION = 100

func jump(direction, delta):
	
	if is_on_floor():
		climb = false
		wall_left = true
		wall_right = true
		wall_jump = false
		DOUBLE_JUMP = INT_DOUBLE_JUMP
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
		return
	
	if velocity.y < 0:
		climb = true
	
	# Handle Wall Jump / climb
	if climb: 
		if ray_cast_right.is_colliding() or ray_cast_left.is_colliding():
			velocity.y = -5
			if Input.is_action_just_pressed("jump") && ray_cast_right.is_colliding():
				velocity.y = JUMP_FORCE
				velocity.x = -18
				block_input = "Right"
				$timer_after_jump.start()
			
			
			if Input.is_action_just_pressed("jump") && ray_cast_left.is_colliding():
				velocity.y = JUMP_FORCE
				velocity.x = 18
				block_input = "Left"
				$timer_after_jump.start()
				
				
	
	# Handle Double Jump
	if Input.is_action_just_released("jump") && velocity.y > JUMP_RELEASED_FORCE :
		velocity.y = JUMP_RELEASED_FORCE
	
	if Input.is_action_just_pressed("jump") && DOUBLE_JUMP > 0 && !ray_cast_left.is_colliding() && !ray_cast_right.is_colliding():
		velocity.y = JUMP_FORCE
		DOUBLE_JUMP -= 1
	

func _on_no_collision_timeout():
	damage_collision = true


func _on_timer_after_jump_timeout():
	block_input = "None"
