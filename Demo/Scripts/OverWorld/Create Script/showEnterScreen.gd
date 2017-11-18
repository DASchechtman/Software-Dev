extends Button

func _ready():
	connect("pressed", self, "clicked")
	
func clicked():
	# makes the enter script node visable
	get_node("EnterScript").set_hidden(!get_node("EnterScript").is_hidden())
