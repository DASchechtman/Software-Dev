extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	connect("pressed", self, "switchScene")
	
func switchScene():
	get_tree().change_scene("res://OverWorld.tscn")
