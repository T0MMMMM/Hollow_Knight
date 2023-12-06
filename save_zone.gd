extends Node3D

var can_save = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$save_text.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("use") && can_save:
		GlobalVariable.player_data.global_position.x = position.x
		GlobalVariable.player_data.global_position.y = position.y + 10
		GlobalVariable.player_data.global_position.z = 0
		GlobalVariable.save_data(GlobalVariable.save_file_path + GlobalVariable.save_file_name)
		$save_text.hide()


func _on_area_3d_body_entered(body):
	if body == get_parent().get_parent().get_node("Player"):
		$save_text.show()
		can_save = true


func _on_area_3d_body_exited(body):
	if body == get_parent().get_parent().get_node("Player"):
		$save_text.hide()
		can_save = false


