extends Node3D
class_name State

@onready var player = owner.get_parent().get_node("enemy").get_parent().get_node("Player")
@onready var ray_cast = owner.get_node("RayCast3D")
@onready var debug = owner.get_node("debug")

func _ready():
	set_physics_process(false)

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass

func _physics_process(delta):
	transition()
	debug.text = name
