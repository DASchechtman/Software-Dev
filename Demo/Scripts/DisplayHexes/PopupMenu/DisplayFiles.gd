extends PopupMenu

var filePaths = {}

func _ready():
	
	#displays the popup menu
	call_deferred("popup")
	
	#get list of hex files to be displayed on the 
	#popup menu
	var fileList = DataShare.get("FileList")
	if fileList == null:
		fileList = []
		
	#adds the name of the files to the popup menu
	for file in fileList:
		var name = file.getName()
		if name[name.length()-1] == '_':
			name = name.substr(0, name.length()-1)
		add_item(name, get_item_count())
		add_separator()
		
		#stores the file to switch to so when the player
		#presses the an element in the popup menue
		#the text in the file will be displayed in
		#the editor menu
		filePaths[file.getName()] = file
		
	connect("item_pressed", self, "pressed")
	
	set_process(true)
	
func _process(delta):
	#keeps the popup menu visable if the player
	#presses anything on the screen that isn't
	#an element in the popup menu
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
