extends Node

# gets access to the character in the game
onready var sprite = get_node("Sprite")

# stores a referance to enemies in the level
var objects_to_move = []

# signle to notify cmaera node to follow the player
signal move

# check to send signle
var emit = false

func _ready():
	var x = 0
	x += 9
#	Interpreter.createPlayer(sprite)
#	DataShare.set("EnemiesList", [])
#	DataShare.set("Player", sprite)
#	var file = FileLoader.new("user://OverworldSave.config")
#	for line in file.read():
#		var l = file.split(line, ':')
#		var nums = file.split(l[1], ',')
#		if l[0] == 'player':
#			DataShare.get("Player").set_pos(Vector2(float(nums[0]), float(nums[1])))
#		elif l[0] == 'enemy':
#			DataShare.get("EnemiesList").push_back(Interpreter.createEnemy(float(nums[0]), float(nums[1]), load("res://icon.png")))
#	if DataShare.get("EnemiesList").size() < 100:
#		randomize()
#		print("working")
#		for i in range(100):
#			var x = rand_range(100, 300) + rand_range(-200, 200)
#			var y = rand_range(100, 300) + rand_range(-200, 200)
#			DataShare.get("EnemiesList").push_back(Interpreter.createEnemy(x, y, preload("res://icon.png")))
#	set_process(true)

func _process(delta):
	var x = 0
	var y = 0
	_checkMove(sprite, x, y, delta)
	if emit:
		emit_signal("move")
		emit = false


func _move(var obj, var x, var y, var delta):
	obj.set_pos(obj.get_pos() + Vector2(x, y)*delta*10)
	emit = true
	
func _checkMove(sprite, x, y, delta):
	if Input.is_action_pressed("ui_up"):
		x = -25
		_move(sprite, 0, x, delta)
	if Input.is_action_pressed("ui_down"):
		x = 25
		_move(sprite, 0, x, delta)
	if Input.is_action_pressed("ui_left"):
		y = -25
		_move(sprite, y, 0, delta)
	if Input.is_action_pressed("ui_right"):
		y = 25
		_move(sprite, y, 0, delta)