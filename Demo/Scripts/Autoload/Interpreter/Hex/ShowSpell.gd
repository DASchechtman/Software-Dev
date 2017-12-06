extends Reference

var sprite = null
var timer = null
var start_time = 1
var end_time = null
var scene = null
var spellTimer = null
var weak_timer_ref = null
var weak_sprite_ref = null
	
func _init(var x, var y, var texture, var ending_time, var cur_scene, var deleteCall):
	end_time = ending_time
	timer = Timer.new()
	sprite = Sprite.new()
	sprite.set_texture(texture)
	sprite.set_pos(Vector2(x, y))
	sprite.set_scale(Vector2(4, 4))
	timer.set_wait_time(1)
	timer.connect("timeout", self, "countDown")
	cur_scene.call_deferred("add_child", timer)
	cur_scene.call_deferred("add_child", sprite)
	scene = cur_scene
	spellTimer = deleteCall
	weak_timer_ref = weakref(timer)
	weak_sprite_ref = weakref(sprite)
	
func start():
	timer.start()

func stop():
	if weak_timer_ref.get_ref() != null and weak_sprite_ref.get_ref() != null:
		timer.stop()
		_deconstruct()

func isTimeUp():
	return start_time == end_time

func _deconstruct():
	weak_timer_ref.get_ref().queue_free()
	weak_sprite_ref.get_ref().queue_free()
	spellTimer = null
	
func countDown():
	if weak_timer_ref.get_ref() == null:
		spellTimer.destroy()
		return
	elif !isTimeUp():
		start_time += 1
	else:
		spellTimer.destroy()

func updatePos(var x, var y):
	if weak_sprite_ref.get_ref() != null:
		sprite.set_pos(Vector2(x, y))
