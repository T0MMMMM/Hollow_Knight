extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(GlobalVariable.save_file_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)


func _on_load_1_pressed():
	GlobalVariable.load_data(GlobalVariable.save_file_path + GlobalVariable.save_file_name)
	#GlobalVariable.player_data = ResourceLoader.load(GlobalVariable.save_file_path + GlobalVariable.save_file_name).duplicate(true)
	get_tree().change_scene_to_file("res://main.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
