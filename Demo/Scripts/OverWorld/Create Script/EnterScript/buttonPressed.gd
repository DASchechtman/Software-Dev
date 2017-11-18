extends LineEdit

func _ready():
	pass


func _on_Ok_pressed():
	# this file will store the names of all the hex files the
	# user creates
	var saveFile = FileLoader.new("user://saveFiles.txt")
	
	# gets what the user just typed in
	var fileName = get_text().split('.')[0]
	
	if fileName.empty() or _has_forbidden_characters(fileName):
		return null
	
	# makes sure that the program will be able to distingush
	# what the user typed in from key words of ManaScript
	if DataShare.get("Keyword").has(fileName):
		fileName += '_'
		
	var hex_file = FileLoader.new("user://"+fileName+'.hex', fileName)
	var indent = '	'
	var script = ['start point\n', indent+'Element: Fire\n', indent+'Time: 1s\n',
	indent+'Power: 1\n', indent+'Action: Burn\n', indent+'Distance: 1\n', indent+'Cast: \n',
	'end point']
	var write = true
	for command in script:
		if write:
			hex_file.write(command)
			write = false
		else:
			hex_file.append(command)
	DataShare.add("FileList", [])
	DataShare.get("FileList").push_back(hex_file)
	saveFile.append("user://"+fileName+'.hex')
	
	set_text("")
	set_hidden(true)

func _has_forbidden_characters(var name):
	var found_forbidden_char = false
	for char in name:
		if _is_forbidden_character(char):
			found_forbidden_char = true
			break
	return found_forbidden_char


func _is_forbidden_character(var char):
	var is_forbidden = false
	
	if (char == '\\' or char == '/' or char == ':' or char == '*'
	or char == '?' or char == '"' or char == '<' or char == '>'
	or char == '|'):
		is_forbidden = true
	
	return is_forbidden

func _on_Cancel_pressed():
	set_hidden(true)
