extends Node

const save_file_path = "user://save/"
const save_file_name = "save.json"
const security_key = "EFA5426G"

@onready var player_data = Player_data.new()

func save_data(path : String) :
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, security_key)
	if file == null :
		print(FileAccess.get_open_error())
		return
	var data = {
		"player_data" : {
			"health" : player_data.health,
			"global_position" : {
				"x" : player_data.global_position.x,
				"y" : player_data.global_position.y
			}
		}
	}
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_data(path : String) :
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, security_key)
		if file == null :
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null :
			printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
			return
		
		player_data = Player_data.new()
		
		player_data.health = data.player_data.health
		player_data.global_position = Vector3(data.player_data.global_position.x, data.player_data.global_position.y, 0)
		
		
	else :
		printerr("Cannot open non existant file at %s" % [path])








