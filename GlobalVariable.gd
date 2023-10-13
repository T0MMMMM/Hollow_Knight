extends Node

var back_option = ""
var player_dir = false

func update_player_dir(body):
	player_dir = body.get_node("Sprite2D").flip_h

