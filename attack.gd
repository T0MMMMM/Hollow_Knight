extends State
class_name attack_state

@export var bullet_node : PackedScene

var dir = [-1, 1]
var direction = 0

func transition():
	if not ray_cast.is_colliding() || ray_cast.get_collider() != player:
		get_parent().change_state("idle")

func enter():
	super.enter()
	$Timer.start()
	
func exit():
	super.exit()
	$Timer.stop()

func _on_timer_timeout():
	shoot()

func shoot():
	var bullet1 = bullet_node.instantiate()
	
	bullet1.position = global_position
	bullet1.direction = (player.global_position - global_position).normalized()
	
	get_tree().current_scene.call_deferred("add_child", bullet1)
	
	var bullet2 = bullet_node.instantiate()
	
	bullet2.position = global_position
	bullet2.direction = (player.global_position - global_position)
	bullet2.direction.y += deg_to_rad(170)
	bullet2.direction = bullet2.direction.normalized()
	
	get_tree().current_scene.call_deferred("add_child", bullet2)
	
	var bullet3 = bullet_node.instantiate()
	
	bullet3.position = global_position
	bullet3.direction = (player.global_position - global_position)
	bullet3.direction.y -= deg_to_rad(170)
	bullet3.direction = bullet3.direction.normalized()
	
	get_tree().current_scene.call_deferred("add_child", bullet3)

func _physics_process(delta):
	transition()
	debug.text = name
	if owner.is_on_floor():
		owner.velocity.y += 8
		direction = dir[randi() % 2]
	owner.velocity.x = direction * owner.speed
