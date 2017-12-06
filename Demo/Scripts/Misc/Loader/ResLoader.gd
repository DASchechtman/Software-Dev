extends Node

func _ready():
	var file = FileLoader.new("user://saveFiles.txt")
	
	var RESERVED_WORD = "Keyword"
	DataShare.set("Keywords", { 
	"Element": RESERVED_WORD, "Cast": RESERVED_WORD, "Time": RESERVED_WORD, 
	"Power": RESERVED_WORD, "Distance": RESERVED_WORD, "Action": RESERVED_WORD, 
	"start": RESERVED_WORD, "end": RESERVED_WORD, "point": RESERVED_WORD, 
	"Fire": RESERVED_WORD, "Water": RESERVED_WORD, "Earth": RESERVED_WORD, 
	"Air": RESERVED_WORD, "Burn": RESERVED_WORD, "If": RESERVED_WORD,
	"Less": RESERVED_WORD, "Greater": RESERVED_WORD, "Mana": RESERVED_WORD,
	"Than": RESERVED_WORD, "Is": RESERVED_WORD 
	})
	
	DataShare.set("FileList", [])
	DataShare.set("CastList", {})

	for line in file.read():
		var hexFile = FileLoader.new(line, _getName(line))
		DataShare.get("FileList").push_back(hexFile)
		DataShare.get("CastList")[hexFile.getName()] = hexFile
	
func _getName(var name):
	var start_of_name = name.find("//")+2
	var end_of_name = name.find(".hex")
	var whole_name = ""
	for char_index in range(start_of_name, end_of_name):
		whole_name += name[char_index]
	return whole_name