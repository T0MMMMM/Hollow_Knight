extends CharacterBody3D


const SPEED = 12.0
const JUMP_VELOCITY = 18.5
const JUMP_RELEASED_FORCE = 8.0
const JUMP_FORCE = 22.0
@export var INT_DOUBLE_JUMP = 0
var DOUBLE_JUMP = INT_DOUBLE_JUMP
var FRICTION = 100
var SPEEDDASH = 70

var climb = true
var fell = false
var gravity = 52
var damage_collision = true
var last_position_on_ground
var block_input = "None"
var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
var coord = position
var dash_enable = true
var wall_left = false
var wall_right = false
var wall_jump = false
var last_velocity = velocity

var enable_wall_jump = false
var enable_dash = false
var update_friction = false

var hanging = true

var dashing = false
var looking_at = "right"
var number_dash = 1
@onready var raycast_left = $collision_with_wall/raycast_left
@onready var raycast_right = $collision_with_wall/raycast_right
@onready var raycast_hang_left = $collision_with_wall/raycast_hang_left
@onready var raycast_hang_right = $collision_with_wall/raycast_hang_right

@onready var fall_particles = $fall_particles
@onready var trail_dash = $trail

@onready var timer_after_jump = $collision_with_wall/timer_after_jump

func _ready():
	position = GlobalVariable.player_data.global_position

func _process(delta):
	$life.text = str(GlobalVariable.player_data.health)
	$coord.text = str(coord)


func _physics_process(delta):
	# Add the gravity
	apply_gravity(delta)
	hang()
	dash(looking_at)
	just_fall()
	
	# Mouvement
	if block_input == "None":
		input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	if block_input == "Right":
		input_dir = Input.get_vector("move_left", "none", "ui_up", "ui_down")
	if block_input == "Left":
		input_dir = Input.get_vector("none", "move_right", "ui_up", "ui_down")
	if block_input == "R&L":
		input_dir = Input.get_vector("none", "none", "ui_up", "ui_down")
		
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.x:
		velocity.x = move_toward(velocity.x, SPEED * direction.x , 10)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		
	if velocity.x > 0:
		$main_chara.rotation.y = deg_to_rad(0)
		looking_at = 1 # 1 = right 
	elif velocity.x < 0:
		$main_chara.rotation.y = deg_to_rad(180)
		looking_at = -1 # -1 = left
		
	# Handle Jump
	jump(direction, delta)
	
	move_and_slide()
	last_velocity = velocity
	
	# COLLISION
	if damage_collision: check_collision()
	
	GlobalVariable.player_data.global_position = position
	coord = position

func check_collision():
	for index in get_slide_collision_count():
			var collision = get_slide_collision(index)
			if collision.get_collider().is_in_group("enemy"):# || collision.get_collider().is_in_group("tears"):
				hit(collision.get_collider())
				collision.get_collider().move_and_collide(velocity)

func hit(mob):
	GlobalVariable.player_data.health -= 10
	velocity.y += 10
	velocity.x += 60 * mob.direction.x
	damage_collision = false
	$no_collision.start()

func apply_gravity(delta):
	position.z = 0
	if not is_on_floor() or dashing:
		FRICTION = 0.4
		velocity.y -= gravity * delta
		velocity.y = min(velocity.y, 250)
	else:
		FRICTION = 100

func jump(direction, delta):
	if is_on_floor():
		hanging = true
		climb = false
		wall_left = true
		wall_right = true
		wall_jump = false
		if enable_dash:
			number_dash = 1
		DOUBLE_JUMP = INT_DOUBLE_JUMP
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
		return
	
	if velocity.y < 0:
		climb = true
		
		
	
	# Handle Wall Jump / climb
	if climb: 
		if raycast_right.is_colliding() or raycast_left.is_colliding():
			velocity.y = -6
			if Input.is_action_just_pressed("jump") && raycast_right.is_colliding() && enable_wall_jump:
				hanging = true
				velocity.y = JUMP_FORCE
				velocity.x = -18
				block_input = "Right"
				timer_after_jump.start()
			
			
			
			if Input.is_action_just_pressed("jump") && raycast_left.is_colliding() && enable_wall_jump:
				hanging = true
				velocity.y = JUMP_FORCE
				velocity.x = 18
				block_input = "Left"
				timer_after_jump.start()
			
			
	
	# Handle Double Jump
	if Input.is_action_just_released("jump") && velocity.y > JUMP_RELEASED_FORCE:
		velocity.y = JUMP_RELEASED_FORCE
	
	if Input.is_action_just_pressed("jump") && DOUBLE_JUMP > 0 && !raycast_left.is_colliding() && !raycast_right.is_colliding():
		velocity.y = JUMP_FORCE
		DOUBLE_JUMP -= 1
		

func dash(sens):
	if Input.is_action_just_pressed("right_click") and enable_dash and number_dash == 1:
		dashing = true
		
		$trail.get_node("GPUParticles3D").restart()
		$trail.get_node("GPUParticles3D").set_emitting(true)
		
		block_input = "R&L"
		velocity.y = 0
		FRICTION = 0
		velocity.x = SPEEDDASH * sens
		number_dash -= 1
		enable_dash = false
		$timer_dash.start()
		$timer_after_dash.start()


func hang():
	if hanging and velocity.y < 0 and ((!raycast_right.is_colliding() and raycast_hang_right.is_colliding()) or (!raycast_left.is_colliding() and raycast_hang_left.is_colliding())):
		if $timer_hang.is_stopped():
			$timer_hang.start()
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE


func _on_no_collision_timeout():
	damage_collision = true


func _on_timer_after_jump_timeout():
	block_input = "None"


func _on_timer_dash_timeout():
	dashing = false
	velocity.x = velocity.x / 10
	block_input = "None"


func _on_timer_after_dash_timeout():
	enable_dash = true


func _on_timer_hang_timeout():
	hanging = false
	
func just_fall():
	if $on_floor.is_colliding() && !is_on_floor() && velocity.y < 0 && $fall_particles.get_node("GPUParticles3D").emitting == false:
		$fall_particles.get_node("GPUParticles3D").restart()
		$fall_particles.get_node("GPUParticles3D").set_emitting(true)
		
		
	
	
