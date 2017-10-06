extends PopupMenu

var filePaths = {}


func _ready():
	call_deferred("popup")
	var fileList = DataShare.get("FileList")
	if fileList == null:
		fileList = []
		
	for file in fileList:
		var name = file.getName()
		if name[name.length()-1] == '_':
			name = name.substr(0, name.length()-1)
		add_item(name, get_item_count())
		add_separator()
		filePaths[file.getName()] = file
		
	connect("item_pressed", self, "pressed")
	
	set_process(true)
	
func _process(delta):
	if is_hidden():
		set_hidden(!is_hidden())
	
func pressed(ID):
	var fileName = get_item_text(ID)
	if DataShare.get("CastList").has(fileName+'_'):
		fileName += '_'
	DataShare.set("CurrentScript", filePaths[fileName])
	get_tree().change_scene("res://EditorScene.tscn")


func _on_Button_pressed():
	get_tree().change_scene("res://OverWorld.tscn")
