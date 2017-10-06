extends LineEdit

func _ready():
	pass


func _on_Ok_pressed():
	
	var saveFile = FileLoader.new("user://saveFiles.txt")
	
	var fileName = get_text()
	if DataShare.get("Keyword").has(fileName):
		fileName += '_'
	if fileName.find(".hex") == -1:
		fileName += ".hex"
		
	DataShare.add("FileList", [])
	DataShare.get("FileList").push_back(FileLoader.new("user://"+fileName, get_text()))
	saveFile.append("user://"+fileName)
	
	set_text("")
	set_hidden(true)


func _on_Cancel_pressed():
	set_hidden(true)
