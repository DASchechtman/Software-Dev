extends Node

var stack = []
var size = 0

func push(var val):
	stack.push_back(val)
	size += 1

func pop():
	if size > 0:
		stack.pop_back()
		size -= 1

func get():
	var val = null
	if size-1 >= 0:
		val = stack[size-1]
	return val

func size():
	return self.size 
