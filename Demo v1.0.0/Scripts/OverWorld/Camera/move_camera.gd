extends Node

onready var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
onready var player = get_tree().get_root().get_node("Node2D/Character/Sprite")
onready var last_player_pos = player.get_pos()

func _ready():
	_updateCanvas(-last_player_pos + screen_size / 2, true) 

func _cameraUpdate():
	var player_offset = last_player_pos - player.get_pos()
	last_player_pos = player.get_pos()
	_updateCanvas(player_offset)
	

func _updateCanvas(var new_pos, var add_or_set = false):
	var canvas_transform = get_viewport().get_canvas_transform()
	if add_or_set:
		canvas_transform[2] = new_pos
	else:
		canvas_transform[2] += new_pos
	get_viewport().set_canvas_transform(canvas_transform)
