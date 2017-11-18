extends Node

func _ready():
	pass

func _on_Button_pressed():
	var file = FileLoader.new("user://OverworldSave.config")
	var player = DataShare.get("Player")
	file.write("player:"+str(player.get_pos().x,',',player.get_pos().y))
	for enemy in DataShare.get("EnemiesList"):
		file.append("enemy:"+str(enemy.get_pos().x,',',enemy.get_pos().y))
	get_tree().change_scene("res://HexPicker.tscn")