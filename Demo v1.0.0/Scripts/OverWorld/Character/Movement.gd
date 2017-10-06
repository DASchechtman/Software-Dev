extends Node

onready var sprite = get_node("Sprite")

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		_move(0, -25, delta)
	if Input.is_action_pressed("ui_down"):
		_move(0, 25, delta)
	if Input.is_action_pressed("ui_left"):
		_move(-25, 0, delta)
	if Input.is_action_pressed("ui_right"):
		_move(25, 0, delta)


func _move(var x, var y, var delta):
	sprite.set_pos(sprite.get_pos() + Vector2(x, y)*(delta*10))