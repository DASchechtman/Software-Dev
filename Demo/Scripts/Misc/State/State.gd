extends Node


class state:
	enum {getPlayer = 0, getAll = 1, getOne = 2}
	var file
	var load_instructions
	var write
	var game_tree
	
	func _init(var tree, var fileName):
		file = FileLoader.new("user://"+fileName+".config")
		write = true
		game_tree = tree
		load_instructions = {}
		for line in file.read():
			var tag = file.split(line, ':')
			if tag[0] == 'player' and !load_instructions.has(tag[0]):
				load_instructions[tag[0]] = tag[1]
			elif tag[0] == 'enemy' and !load_instructions.has(tag[0]):
				load_instructions[tag[0]] = [0, [tag[1]]]
			elif tag[0] == 'enemy':
				load_instructions[tag[0]][1].push_back(tag[1])
	
	func _isBuiltInType(var obj):
		var retvar = false
		if typeof(obj) == typeof([]):
			retvar = true
		elif typeof(obj) == typeof(0):
			retvar = true
		return retvar
	
	func reset():
		write = true
	
	func clear():
		file.write("")
		load_instructions.clear()
	
	func Save(var tag, var obj, var single_save = false):
		if !_isBuiltInType(obj) and obj.has_method("get_pos"):
			var saveData = tag+':'+str(obj.get_pos().x, ',', obj.get_pos().y)
			if write or single_save:
				file.write(saveData)
				write = false
			else:
				file.append(saveData)
		elif typeof(obj) == typeof([]):
			for sub_obj in obj:
				Save(tag, sub_obj)
	
	func Load(var tag, var obj):
		if load_instructions.empty() or !load_instructions.has(tag):
			return false
		elif tag == 'player' and obj == getPlayer:
			var coords = file.split(load_instructions[tag], ',')
			var player_sprite = game_tree.get_root().get_node("Node2D/Character/Sprite")
			
			if player_sprite == null:
				player_sprite = Sprite.new()
				_add_to_tree(player_sprite)
			
			player_sprite.set_pos(Vector2(float(coords[0]), float(coords[1])))
			DataShare.set("Player", Interpreter.createPlayer(player_sprite, 100, 100))
		elif obj == getAll:
			while true:
				if _load_state_in(tag):
					break
		elif obj == getOne:
			_load_state_in(tag)
		return true

	func _load_state_in(var tag):
		var instruction_to_process = load_instructions[tag][0]
		if instruction_to_process >= load_instructions[tag][1].size():
			return true
		var coords = file.split(load_instructions[tag][1][instruction_to_process], ',')
		var e = "res://icon.png"
		var enemy = Interpreter.createEnemy(float(coords[0]), float(coords[1]), 100, 100, load(e))
		DataShare.get("EnemiesList").push_back(enemy)
		load_instructions[tag][0] = instruction_to_process + 1
		return false
	
	func _add_to_tree(var sprite):
		var root = game_tree.get_root()
		var cur_scene = root.get_child(root.get_child_count()-1)
		cur_scene.call_deferred("add_child", sprite)

func new(var fileName):
	return state.new(get_tree(), fileName)