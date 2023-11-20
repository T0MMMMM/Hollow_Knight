extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("option") :
		get_tree().paused = !get_tree().paused
		hide()


func _on_save_pressed():
	GlobalVariable.save_data(GlobalVariable.save_file_path + GlobalVariable.save_file_name)
	get_tree().paused = !get_tree().paused
	hide()
	#ResourceSaver.save(GlobalVariable.player_data, GlobalVariable.save_file_path + GlobalVariable.save_file_name)


func _on_back_pressed():
	get_tree().paused = !get_tree().paused
	hide()


func _on_load_pressed():
	GlobalVariable.load_data(GlobalVariable.save_file_path + GlobalVariable.save_file_name)
	get_parent().get_parent().get_node("Player").position = GlobalVariable.player_data.global_position
	get_tree().paused = !get_tree().paused
	hide()
