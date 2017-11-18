extends Reference

class Spell extends Reference:
	var sprite = null
	var timer = null
	var start_time = 1
	var end_time = null
	var scene = null
	var spellTimer = null
	var index
	
	func _init(var x, var y, var texture, var ending_time, var cur_scene, var deleteCall, var i):
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
		index = i
	
	func start():
		timer.start()

	func stop():
		timer.stop()
		_deconstruct()

	func isTimeUp():
		return start_time == end_time

	func _deconstruct():
		timer.queue_free()
		sprite.queue_free()
		timer = null
		sprite = null
	
	func countDown():
		if !isTimeUp():
			start_time += 1
		else:
			spellTimer.destroy(index)

	func updatePos(var x, var y):
		if sprite != null:
			sprite.set_pos(Vector2(x, y))
		
static func new(var x, var y, var texture, var ending_time, var scene, var signle, var size):
	return Spell.new(x, y, texture, ending_time, scene, signle, size)
