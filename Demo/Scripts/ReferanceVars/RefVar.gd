extends Reference

class RefVar:
	var value = null
	
	func _init(var val):
		value = val
	
	func set(var new_val):
		value = new_val
	
	func get():
		return value
		
static func new(var val):
	return RefVar.new(val)