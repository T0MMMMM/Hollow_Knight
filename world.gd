extends Node2D


func _ready():
	pass


func _process(delta):
	if Input.is_action_pressed("option"):
		GlobalVariable.back_option = "res://world.tscn"
		get_tree().change_scene_to_file("res://option.tscn")

