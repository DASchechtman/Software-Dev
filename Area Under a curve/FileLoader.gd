extends Node

class FileGet extends Reference:
	
	var path
	var name
	var file
	
	func _init(var path, var name):
		self.path = path
		self.name = name
		file = File.new()
		if !file.file_exists(path):
			write("")
		
	func write(var string):
		file.open(path, File.WRITE)
		file.store_string(string)
		file.close()
	
	func read():
		file.open(path, File.READ)
		
		var read_in_file = []
		
		while !file.eof_reached():
			var line = file.get_line()
			if !line.empty():
				read_in_file.push_back(line)
		
		return read_in_file
	
	func append(var string):
		var append_text = ""
		for line in read():
			append_text += line+'\n'
		append_text += string+'\n'
		write(append_text)
		
	func getPath():
		return path
	
	func getName():
		return name
		
	func split(var string, var char):
		var ret = []
		var msg = ""
		for s in string:
			if s == char:
				ret.push_back(msg)
				msg = ""
			else:
				msg += s 
		ret.push_back(msg)
		return ret

static func new(var path, var name = null):
	return FileGet.new(path, name)