extends Button

var timer
var count = 0
var start = true

func _ready():
	connect("pressed", self, "castSpell") 
	timer = Timer.new()
	timer.set_wait_time(.01)
	timer.connect("timeout", self, "count")
	var root = get_tree().get_root()
	var cur_scene = root.get_child(root.get_child_count()-1)
	cur_scene.call_deferred("add_child", timer)
	#timer.start()
	

func count():
	if start:
		var file = FileLoader.new("user://test.hex")
		Interpreter.compile(file, "Player")
		start = false
	castSpell()

func castSpell():
	for e in DataShare.get("EnemiesList"):
		Interpreter.cast(e)