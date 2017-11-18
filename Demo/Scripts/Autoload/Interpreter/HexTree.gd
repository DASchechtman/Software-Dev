extends Reference

#This class will be used to store Hex objects
#in a tree like fashion in memory
#This will make accessing each spell
#pretty quick, and if I decide to make a 
#file system for the game, then this will allow me
#to more easily structure it base off the
#hexes in computer memory
const node = preload("HexNode.gd")

class HexTree extends Reference:
	var root
	var tree
	var ref = preload("res://Scripts/ReferanceVars/RefVar.gd").new(0)
	const node = preload("HexNode.gd")
	var damage = 0.0
	var node_tbl = {}
	var root_name
	
	func _init(var hex = null, var name = null, var parser = null, var game_tree = null):
		if game_tree != null:
			tree = game_tree
			
		if hex != null and parser != null and tree != null:
			root_name = name
			if name == null:
				root_name = "Root"
			damage = hex.Power()
			root = node.new(hex, name, tree, ref)
			_createChildren(root, parser, ref)
	
	func getNode(var key):
		var node = root
		if node_tbl.has(key):
			for index in node_tbl[key]:
				node = node.getChildList()[index]
		elif key != root_name:
			node = null
		return node
	
	func _createChildren(var new_node, var parser, var ref, var path = null):
		# gets the list of spells stored in memory
		var spells = DataShare.get("CastList")
		
		for i in range(new_node.getHex().Cast().size()):
			var spell = new_node.getHex().Cast()[i]
			if node_tbl.has(spell):
				continue
			
			# Makes sure that if a spell name is the same as a keyword
			# it can be decoded properly to get the name of the
			# file
			if spells.has(spell+'_'):
				spell = spell + '_'
			if not _has_forbidden_characters(spell):
				var file = FileLoader.new('user://'+spell+'.hex', spell)
				var childHex = parser.compile(file)
				if (not file.empty() and childHex.Start() == 'point' and childHex.End() == 'point'):
					node_tbl[spell] = []
					if path != null:
						for node in path:
							node_tbl[spell].push_back(node)
					damage += childHex.Power()
					new_node.addChildName(node.new(childHex, spell, tree, ref))
					node_tbl[spell].push_back(new_node.getChildList().size()-1)
					var child_list = new_node.getChildList()
					var list_size = child_list.size()
					_createChildren(child_list[list_size-1], parser, ref, node_tbl[spell])
				else:
					node_tbl.erase(spell)
				
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
	
	func _setNodesHelper(var new_root, var old_root):
		for child in old_root.getChildList():
			damage += new_root.getHex().Power()
			var name = child.getNodeName()
			new_root.addChildName(node.new(child.getHex(), name, tree, ref))
			var size = new_root.getChildList().size()
			_setNodesHelper(new_root.getChildList()[size-1], child)
	
	func _setNodes(var old_root, var name, var game_tree):
		tree = game_tree
		root_name = name
		root = node.new(old_root.getRoot().getHex(), name, tree, ref)
		damage += old_root.getRoot().getHex().Power()
		_setNodesHelper(root, old_root.getRoot())
		for spell in old_root.getNodeTable():
			node_tbl[spell] = []
			for index in old_root.getNodeTable()[spell]:
				node_tbl[spell].push_back(index)
	
	func stop():
		_stop_helper(root)
		
	func getNodeTable():
		return node_tbl
	
	func _stop_helper(var root):
		for node in root.getChildList():
			_stop_helper(node)
		root.stop()
	
	func getDamage():
		return float(damage)
	
	func isActive():
		return ref.get() != 0
	
	func getRoot():
		return root
	
	func getTree():
		return tree
	
	func getName():
		return root.getNodeName()
	
	func getRef():
		return ref
		
	func updatePos(var x, var y):
		_updatePos_helper(root, x, y)
	
	func _updatePos_helper(var node, var x, var y):
		for spell in node.getChildList():
			_updatePos_helper(spell, x, y)
		node.updatePos(x, y)
			
	func cast(var x, var y):
		_cast_helper(root, root.getChildList(), x, y)
	
	func _cast_helper(var spell, var castList, var x, var y):
		for spell_to_cast in castList:
			_cast_helper(spell_to_cast, spell_to_cast.getChildList(), x, y)
		spell.cast(x, y)
	
static func new(var hex = null, var name = null, var parser = null, var tree = null):
	return HexTree.new(hex, name, parser, tree)
	
static func clone(var tree):
	var x = 0
	if tree != null:
		var retTree = HexTree.new()
		var name = tree.getName()
		if name == null:
			name = "Root"
		retTree._setNodes(tree, name, tree.getTree())
		var x = 0
		return retTree
	return null