extends CharacterBody2D

@export var SPEED = 90.0
@export var SPEED_RUN = 110.0
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
var jump = false
var run = false

func _physics_process(delta):
	walk = false
	jump = false
	run = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		jump = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	
	
	if input.x == 0:
		apply_friction()
	elif Input.is_action_pressed("shift"):
		apply_acceleration(input.x, SPEED_RUN)
		run = true
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		apply_acceleration(input.x, SPEED)
		walk = true
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	# Handle Jump.
	if is_on_floor():
		fast_fell = false
		if Input.is_action_pressed("jump"):
			velocity.y = -JUMP_FORCE
			jump = true
			$AnimatedSprite2D.play("idle") # reset l'animation
	else:
		if Input.is_action_just_released("jump") and velocity.y < -JUMP_RELEASED_FORCE:
			velocity.y = -JUMP_RELEASED_FORCE
		
		if Input.is_action_pressed("down"):
			velocity.y += ADDITIONAL_JUMP_GRAVITY_DOWN
		
		if velocity.y > 0 and not fast_fell:
			velocity.y += ADDITIONAL_JUMP_GRAVITY
			fast_fell = true
	
	if jump:
		$AnimatedSprite2D.play("jump")
	elif run:
		$AnimatedSprite2D.play("run")
	elif walk:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	up_direction = Vector2.UP
	move_and_slide()
	
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount, speed):
	velocity.x = move_toward(velocity.x, speed * amount, ACCELERATION)


