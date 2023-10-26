extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 14.5
const JUMP_RELEASED_FORCE = 6.0
const JUMP_FORCE = 22.0
@export var DOUBLE_JUMP = 1
var gravity = 52


func _physics_process(delta):
	# Add the gravity.
	velocity.z = 0
	if not is_on_floor():
		velocity.y -= gravity * delta
		velocity.y = min(velocity.y, 250)

	# Handle Jump.
	if is_on_floor():
		DOUBLE_JUMP = 1
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
	else:
		if Input.is_action_just_released("jump") and velocity.y > JUMP_RELEASED_FORCE:
			velocity.y = JUMP_RELEASED_FORCE
		
		if Input.is_action_just_pressed("jump") and DOUBLE_JUMP > 0:
			velocity.y = JUMP_FORCE
			DOUBLE_JUMP -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
