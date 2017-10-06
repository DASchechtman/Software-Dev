extends Node

var name = null
var val = null

func _init(var name, var val):
	self.name = name
	self.val = val
	
func getName():
	return name

func getVal():
	return val
