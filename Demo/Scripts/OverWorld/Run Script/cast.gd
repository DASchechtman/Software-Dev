extends Button

func _ready():
	connect("pressed", self, "castSpell") 

func castSpell():
	for e in DataShare.get("EnemiesList"):
		Interpreter.cast(e)