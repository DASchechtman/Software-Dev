extends Button

func _ready():
	connect("pressed", self, "clicked")
	
func clicked():
	get_node("EnterScript").set_hidden(!get_node("EnterScript").is_hidden())
