extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	connect("pressed", self, "compile")

func compile():
	var file = DataShare.get("CurrentScript")
	Interpreter.compile(file, "Player")
