extends Node

var data = {}

func add(var key, var data):
	if !self.data.has(key):
		self.data[key] = data

func set(var key, var data):
	if self.data.has(key):
		self.data[key] = data
	else:
		add(key, data)

func get(var key):
	var requestedData = null
	if data.has(key):
		requestedData = data[key]
	return requestedData

func delete(var key):
	if data.has(key):
		data.erase(key) 