extends Node

# gets access to the character in the game
onready var sprite = get_node("Sprite")
onready var mana_bar = get_node("Sprite/ManaBar")
onready var health_bar = get_node("Sprite/HealthBar")
onready var can_move_player = get_node("Sprite/CreateScript/EnterScript")

# stores a referance to enemies in the level
var objects_to_move = []

# signle to notify cmaera node to follow the player
signal move

# check to send signle
var emit = false
var state
var breakPoint = false

func _ready():
	
	# will store a list of enemies that will be accessable
	# throughout the entire scene
	DataShare.set("EnemiesList", [])
	
	# allows the player object to be accessable
	# throughout the scene
	DataShare.set("Player", null)
	
	# object responcible for saving and loading the
	# state of the scene. This is used to keep the state
	# of a scene when the player switches to another scene
	state = State.new("OverworldSave")
	
	# loads the orignal state of the player
	# and the enemies
	state.Load('player', state.getPlayer)
	if DataShare.get("Player") == null:
		sprite = Interpreter.createPlayer(sprite, 100, 100)
		DataShare.set("Player", sprite)
	else:
		sprite = DataShare.get("Player")
		
	# if there is no previous state for the enemies creates new enemies
	var times = 4
	
	for i in range(times):
		state.Load('enemy', state.getOne)
	
	
	if DataShare.get("EnemiesList").size() < times:
		var offset = DataShare.get("EnemiesList").size()
		
		# makes sure that numbers are randomly generated
		# each time, instead of having the same sequence
		# each time the program runs
		randomize()
		for i in range(times - offset):
			var x = rand_range(100, 300) + rand_range(-200, 200)
			var y = rand_range(100, 300) + rand_range(-200, 200)
			
			# adds enemy nodes to a list of enemies that can be accessed
			# throughout the entire scene
			DataShare.get("EnemiesList").push_back(Interpreter.createEnemy(x, y, 100, 100, load("res://icon.png")))
	set_process(true)

func get_sprite():
	return sprite

func _process(delta):
	mana_bar.change(sprite.get_mana())
	health_bar.change(sprite.getHP())
	# variables used to move the player around
	var x = 0
	var y = 0
	
	# checks if the player hits any of the arrow keys
	# so it will move the player
	if !can_move_player.is_visible():
		_checkMove(sprite, x, y, delta)
	
	# signles the camera node to update its position
	# so it can follow the player
	if emit:
		for enemy in DataShare.get("EnemiesList"):
			_move(enemy, 5, 0, delta)
		emit_signal("move")
		emit = false
	
	Interpreter.updateSpells()
	if !sprite.is_using_magic():
		mana_bar.recover(sprite)

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