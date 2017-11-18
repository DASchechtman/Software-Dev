extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	var v = Vector2(100, 0)
	set_pos(get_pos()+v*delta)