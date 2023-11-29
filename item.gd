extends Area3D

@export var TYPE = "add_jump"

func _on_body_entered(body):
	if body == get_parent().get_node("Player"):
		var power = ""
		if TYPE == "add_jump":
			add_jump()
			power = "double jump"
		if TYPE == "add_dash":
			add_dash()
			power = "dash"
		if TYPE == "add_wall_jump":
			add_wall_jump()
			power = "wall jump"
		queue_free()
		get_parent().get_node("text_box").add_text(" U GOT A FUCKING POWER UP : "+power)
		get_tree().paused = !get_tree().paused
		get_parent().get_node("text_box").show()


func add_jump():
	get_parent().get_node("Player").INT_DOUBLE_JUMP += 5
	
func add_dash():
	get_parent().get_node("Player").enable_dash = true
	
func add_wall_jump():
	get_parent().get_node("Player").enable_wall_jump = true
	

