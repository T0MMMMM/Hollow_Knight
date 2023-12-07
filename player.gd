extends CharacterBody3D


const SPEED = 12.0
const JUMP_VELOCITY = 18.5
const JUMP_RELEASED_FORCE = 8.0
const JUMP_FORCE = 22.0
const LIFE_TEXTURE = [Rect2(27,44,101,118), Rect2(198,38,101,118), Rect2(387,31,101,118), Rect2(572,26,101,118), Rect2(781,21,101,118)]
@export var INT_DOUBLE_JUMP = 0
var DOUBLE_JUMP = INT_DOUBLE_JUMP
var FRICTION = 1000
var SPEEDDASH = 70

var user_off = false

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

var enable_wall_jump = true
var enable_dash = false
var update_friction = false

var changeFriction = false
var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

var hanging = true

var dashing = false
var looking_at = 1
var number_dash = 1
@onready var raycast_left = $collision_with_wall/raycast_left
@onready var raycast_right = $collision_with_wall/raycast_right
@onready var raycast_hang_left = $collision_with_wall/raycast_hang_left
@onready var raycast_hang_right = $collision_with_wall/raycast_hang_right

@onready var fall_particles = $fall_particles
@onready var trail_dash = $trail

@onready var timer_after_jump = $collision_with_wall/timer_after_jump

func _ready():
	#position = GlobalVariable.player_data.global_position
	pass

func _process(delta):
	$life.text = str(GlobalVariable.player_data.health)
	$coord.text = str(coord)





func _physics_process(delta):
	
	if user_off :
		return
	
	# Add the gravity
	apply_gravity(delta)
	hang()
	dash(looking_at)
	attack(looking_at)
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
		
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.x:
		velocity.x = move_toward(velocity.x, SPEED * direction.x , 10)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	if velocity.x == 0:
		$main_chara/AnimationPlayer.play("Armature_004Action_001")
	
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
	
	#GlobalVariable.player_data.global_position = position
	coord = position

func check_collision():
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("enemy"):# || collision.get_collider().is_in_group("tears"):
			hit(collision.get_collider())
			collision.get_collider().move_and_collide(velocity)


func damage():
	GlobalVariable.player_data.health -= 1
	print("aa")
	get_parent().get_node("HUD").get_node("Control").get_node("life").region_rect = LIFE_TEXTURE[5-GlobalVariable.player_data.health]
	if user_off :
		return
	if GlobalVariable.player_data.health == 0 :
		death()
		return

func hit(mob):
	damage()
	velocity.y += 10
	velocity.x += 60 * mob.direction.x
	damage_collision = false
	$no_collision.start()

func death():
	user_off = true
	hide()
	get_parent().get_node("Transition_fondu").transition()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		velocity.y = min(velocity.y, 250)
		if changeFriction and direction.x != 0:
			FRICTION = 1000
			changeFriction = false
			
	elif !dashing:
		FRICTION = 1000

func jump_after_floor():
	if $jumpRight.is_colliding() and looking_at == -1:
		return true
	elif $jumpLeft.is_colliding() and looking_at == 1:
		return true
	else:
		return false


func jump(direction, delta):
	if is_on_floor() or jump_after_floor():
		hanging = true
		climb = false
		wall_left = true
		wall_right = true
		wall_jump = false
		changeFriction = false
		if enable_dash:
			number_dash = 1
		DOUBLE_JUMP = INT_DOUBLE_JUMP
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
	
	if velocity.y < 0:
		climb = true
		
	# Handle Wall Jump / climb
	if climb: 
		if raycast_right.is_colliding() or raycast_left.is_colliding():
			velocity.y = -6
			update_friction = true
			if !(hanging and velocity.y < 0 and ((!raycast_right.is_colliding() and raycast_hang_right.is_colliding()) or (!raycast_left.is_colliding() and raycast_hang_left.is_colliding()))):
				FRICTION = 0.3
				
				
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
		
		

func attack(sens):
	if Input.is_action_just_pressed("attack"):
		print("attack")


func dash(sens):
	if Input.is_action_just_pressed("right_click") and enable_dash and number_dash == 1:
		dashing = true
		FRICTION = 0
		$trail.get_node("GPUParticles3D").restart()
		$trail.get_node("GPUParticles3D").set_emitting(true)	
		block_input = "R&L"
		velocity.y = 0
		velocity.x = SPEEDDASH * sens
		number_dash -= 1
		enable_dash = false
		$timer_dash.start()
		$timer_after_dash.start()


func hang():
	if hanging and velocity.y < 0 and ((!raycast_right.is_colliding() and raycast_hang_right.is_colliding() and looking_at == 1) or (!raycast_left.is_colliding() and raycast_hang_left.is_colliding() and looking_at == -1)):
		if $timer_hang.is_stopped():
			$timer_hang.start()
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE


func _on_no_collision_timeout():
	damage_collision = true


func _on_timer_after_jump_timeout():
	block_input = "None"
	changeFriction = true


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
		

# TRANSITION FONDU NOIR
func _on_transition_fondu_transitioned():
	show()
	GlobalVariable.load_data(GlobalVariable.save_file_path + GlobalVariable.save_file_name)
	GlobalVariable.player_data.health = 5
	get_parent().get_node("HUD").get_node("Control").get_node("life").region_rect = LIFE_TEXTURE[5-GlobalVariable.player_data.health]
	position = GlobalVariable.player_data.global_position
	get_parent().get_node("Camera3D").cam_pos(position)
	user_off = false

