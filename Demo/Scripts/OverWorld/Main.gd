extends Node

func _on_Button_pressed():
	# saves the position of all the characters on the screen
	# to disk so it can be loaded back into memory later
	var state = State.new("OverworldSave")
	state.Save("player", DataShare.get("Player"))
	state.Save("enemy", DataShare.get("EnemiesList"))
	get_tree().change_scene("res://HexPicker.tscn")