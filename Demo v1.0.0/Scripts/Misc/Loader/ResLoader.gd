extends Node

var client
var retry = 0
var switchScene = true
var changable = false

func _ready():
	var file = FileLoader.new("user://saveFiles.txt")
	var curFile = FileLoader.new("user://currentScript.txt")
	
	var key = "Keyword"
	var keywords = {"Element": key, "Cast": key, "Time": key, "Power": key, "Distance": key, "Action": key, "start": key, "end": key, "point": key, "Fire": key, "Water": key, "Earth": key, "Air": key }
	DataShare.add("FileList", [])
	DataShare.add("CastList", {})
	DataShare.add("Keyword", keywords)

	for line in file.read():
		var hexFile = FileLoader.new(line, _getName(line))
		var name = hexFile.getName()
		var temp_name = name
		if hexFile.getName().find('_') > -1:
			temp_name = name.substr(0, name.length()-1)
		print(name, ' : ', temp_name)
		DataShare.get("FileList").push_back(hexFile)
		DataShare.get("CastList")[hexFile.getName()] = hexFile
	
func _getName(var name):
	name = name.substr(7, name.length()-1)
	var repName = ""
	var index = 0
	while index != name.find(".hex"):
		repName += name[index]
		index += 1
	name = repName
	return name