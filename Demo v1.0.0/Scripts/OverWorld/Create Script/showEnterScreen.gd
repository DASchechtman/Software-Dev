extends Button

func _ready():
	connect("pressed", self, "clicked")
	
func clicked():
	print("working")
	get_node("EnterScript").set_hidden(!get_node("EnterScript").is_hidden())
