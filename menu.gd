extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	preload("res://main.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://save_menu.tscn")


func _on_option_pressed():
	get_tree().paused = !get_tree().paused
	$CanvasLayer/paused.show()


func _on_exit_pressed():
	get_tree().quit()
