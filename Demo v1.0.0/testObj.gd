extends Node

class ref:
	var v
	func _init(var s):
		v = s
	
	func get():
		return v
	
	func set(var new_v):
		v = new_v

var obj_list = []

func create(var val):
	var r = ref.new(val)
	obj_list.push_back(r)
	return r

func get(var index):
	return obj_list[index]


	