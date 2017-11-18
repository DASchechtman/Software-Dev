extends Node

var current_scene_path = null
var scenes = {}

func _ready():
    # Fetch the current scene and add it to the scenes dictionary
    var current_scene = get_tree().get_current_scene()
    current_scene_path = current_scene.get_path()
    scenes[current_scene_path] = current_scene

func change_scene(path):
    call_deferred("_change_scene", path)

func _change_scene(path):
	if current_scene_path == path:
		print("working")
		return 
    	# Can't switch to the scene we are currently in

	if not path in scenes:
    	# If path is not scenes then load the scene from disk and then switch to it
    	var s = load(path)
    	var scene = s.instance()
    	scenes[path] = scene
    	return _change_scene(path)

    # Remove the current scene from the scene tree
	get_tree().get_root().remove_child(scenes[current_scene_path])

    # Load the already loaded scene from the scenes dictionary
	var scene = scenes[path]
	current_scene_path = path
	get_tree().get_root().add_child(scene)
	get_tree().set_current_scene(scene)
	return null