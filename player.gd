extends CharacterBody2D

@export var SPEED = 90.0
@export var SPEED_RUN = 110.0
@export var DOUBLE_JUMP = 1
@export var JUMP_FORCE = 200.0
@export var JUMP_RELEASED_FORCE = 100.0
@export var ACCELERATION = 10.0
@export var FRICTION = 10.0
@export var ADDITIONAL_JUMP_GRAVITY = 10.0
@export var ADDITIONAL_JUMP_GRAVITY_DOWN = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 575
var fast_fell = false
var walk = false
var jumping = false
var run = false
var attack = false
var dir = false

func _physics_process(delta):
	walk = false
	jumping = false
	run = false
	attack = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 250)
	
	# Attack
	if Input.is_action_pressed("attack") || $AnimationPlayer.current_animation == "attack" || $AnimationPlayer.current_animation == "attack_2": #|| ($AnimationPlayer.animation == "attack" && $AnimationPlayer.frame < 7):
		attack = true
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	
	if input.x == 0:
		apply_friction()
	elif Input.is_action_pressed("shift"):
		apply_acceleration(input.x, SPEED_RUN)
		run = true
		if !attack: $Sprite2D.flip_h = velocity.x < 0
		else: dir = velocity.x < 0
	else:
		apply_acceleration(input.x, SPEED)
		walk = true
		if !attack: $Sprite2D.flip_h = velocity.x < 0
		else: dir = velocity.x < 0
	
	
	# Handle Jump.
	if is_on_floor():
		fast_fell = false
		DOUBLE_JUMP = 1
		if Input.is_action_just_pressed("jump"):
			velocity.y = -JUMP_FORCE
			if !attack:
				jumping = true
				$AnimationPlayer.play("idle") # reset l'animation
	else:
		if $AnimationPlayer.is_playing():
			if $AnimationPlayer.current_animation_position < 7 && $AnimationPlayer.current_animation == "jump":
				jumping = true
		
		if Input.is_action_just_released("jump") and velocity.y < -JUMP_RELEASED_FORCE:
			velocity.y = -JUMP_RELEASED_FORCE
		
		if Input.is_action_just_pressed("jump") and DOUBLE_JUMP > 0:
			velocity.y = -JUMP_FORCE
			DOUBLE_JUMP -= 1
			if !attack:
				jumping = true
				$AnimationPlayer.play("idle")
		
		if Input.is_action_pressed("down"):
			velocity.y += ADDITIONAL_JUMP_GRAVITY_DOWN
		
		if velocity.y > 0 and not fast_fell:
			velocity.y += ADDITIONAL_JUMP_GRAVITY
			fast_fell = true
	
	if attack && $Sprite2D.flip_h == false && !$AnimationPlayer.current_animation == "attack_2":
		$AnimationPlayer.play("attack")
	elif attack && $Sprite2D.flip_h == true && !$AnimationPlayer.current_animation == "attack":
		$AnimationPlayer.play("attack_2")
	elif jumping:
		$AnimationPlayer.play("jump")
	elif run:
		$AnimationPlayer.play("run")
	elif walk:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	up_direction = Vector2.UP
	move_and_slide()
	
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount, speed):
	velocity.x = move_toward(velocity.x, speed * amount, ACCELERATION)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		$Sprite2D.flip_h = dir#pass#turn(dir)

