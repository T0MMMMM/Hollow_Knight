extends State
class_name idle_state

func transition():
	if ray_cast.is_colliding() && ray_cast.get_collider() == player:
		get_parent().change_state("attack")

func enter():
	super.enter()

func exit():
	super.exit()

func _physics_process(delta):
	transition()
	debug.text = name
	owner.velocity.x = 0
	if owner.is_on_floor():
		owner.velocity.y += 6
