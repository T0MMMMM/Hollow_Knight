extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	preload("res://node.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://node_3d.tscn")


func _on_option_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
