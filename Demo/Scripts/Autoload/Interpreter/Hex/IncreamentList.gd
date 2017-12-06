extends Reference

class StackList extends Reference:
	var list = null
	var index = null
	
	func _init(var new_list = []):
		list = new_list
		index = 0

	func add(var val):
		list.push_back(val)

	func get():
		var ret_val = null
		if index < list.size():
			ret_val = list[index]
		return ret_val

	func next():
		if index < list.size():
			index += 1

	func prev():
		if index > 0:
			index -= 1

	func set(var new_index):
		if new_index < 0:
			index = 0
		elif not list.empty() and new_index >= list.size():
			index = list.size() - 1
		else:
			index = new_index

	func hasNext():
		return index < list.size()
		
static func new():
	return StackList.new()