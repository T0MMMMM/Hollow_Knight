extends CanvasLayer

var index = 0
var next_text = " / PLACEHOLDER / "

@onready var label = $text_box_container/MarginContainer/HBoxContainer/text

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_text_box()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		if !$timer_char.is_stopped():
			label.text = next_text
			phase_2()
		else :
			get_tree().paused = !get_tree().paused
			hide_text_box()

func hide_text_box():
	$text_box_container/MarginContainer/HBoxContainer/start_symbol.text = ""
	$text_box_container/MarginContainer/HBoxContainer/end_symbol.text = ""
	label.text = ""
	index = 0
	next_text = " / PLACEHOLDER / "
	$text_box_container.hide()
	
func show_text_box():
	$text_box_container/MarginContainer/HBoxContainer/start_symbol.text = "*"
	$text_box_container/MarginContainer/HBoxContainer/end_symbol.text = "_"
	$text_box_container.show()
	
func add_text(next):
	next_text = next
	label.text += next_text[index]
	show_text_box()
	$timer_char.start()

func _on_timer_char_timeout():
	index += 1
	label.text += next_text[index]
	if index >= len(next_text) - 1 :
		phase_2()
		return
	$timer_char.start()

func phase_2():
	$timer_end_symbol.wait_time = 1.0
	$text_box_container/MarginContainer/HBoxContainer/end_symbol.show()
	$timer_end_symbol.start()
	$timer_char.stop()

func _on_timer_end_symbol_timeout():
	if $text_box_container/MarginContainer/HBoxContainer/end_symbol.is_visible_in_tree():
		$text_box_container/MarginContainer/HBoxContainer/end_symbol.hide()
		$timer_end_symbol.wait_time = 1.0
	else :
		$text_box_container/MarginContainer/HBoxContainer/end_symbol.show()
		$timer_end_symbol.wait_time = 0.5
	



