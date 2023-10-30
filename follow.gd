extends State

func transition():
	if ray_cast.is_colliding():
		get_parent().change_state("attack")

func enter():
	super.enter()
	
func exit():
	super.exit()

func _physics_process(delta):
	transition()
	debug.text = name
	owner.gravity = 15
	if owner.is_on_floor():
		owner.velocity.y += 7
	owner.velocity.x = owner.direction.x * owner.speed
