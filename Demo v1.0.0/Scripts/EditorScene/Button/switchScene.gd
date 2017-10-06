extends Button

func _init():
	print("loaded")

func _ready():
	connect("pressed", self, "switchScene")
	
func switchScene():
	get_tree().change_scene("HexPicker.tscn")
