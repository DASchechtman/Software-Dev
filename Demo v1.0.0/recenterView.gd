extends Node

onready var canvas = get_viewport().get_canvas_transform()

func _ready():
	canvas[2] = Vector2(0, 0)
	get_viewport().set_canvas_transform(canvas)

