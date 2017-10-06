extends TextEdit

var file = null

func _ready():
	file = DataShare.get("CurrentScript")
	var fileText = ""
	for line in file.read():
		fileText += line+"\n"
	set_text(fileText)
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.KEY:
		file.write(get_text())
