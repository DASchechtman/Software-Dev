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
	var ref = load("res://Scripts/ReferanceVars/RefVar.gd").new(0)
	const node = preload("HexNode.gd")
	
	func _init(var hex = null, var name = null, var parser = null, var game_tree = null):
		if game_tree != null:
			tree = game_tree
			
		if hex != null and parser != null and tree != null:
			if name == null:
				name = "Root"
			root = node.new(hex, name, tree, ref)
			_createChildren(root, parser, ref)
	
	func _createChildren(var new_node, var parser, var ref):
		# gets the list of spells stored in memory
		var spells = DataShare.get("CastList")
		
		for spell in new_node.getHex().Cast():
			# Makes sure that if a spell name is the same as a keyword
			# it can be decoded properly to get the name of the
			# file
			if spells.has(spell+'_'):
				spell = spell + '_'
			
			var file = FileLoader.new('user://'+spell+'.hex', spell)
			var childHex = parser.compile(file)
			new_node.addChildName(node.new(childHex, spell, tree, ref))
			_createChildren(new_node.getChildList()[new_node.getChildList().size()-1], parser, ref)
	
	func _setNodesHelper(var new_root, var old_root):
		for child in old_root.getChildList():
			var name = child.getNodeName()
			new_root.addChildName(node.new(child.getHex(), name, tree, ref))
			var size = new_root.getChildList().size()
			_setNodesHelper(new_root.getChildList()[size-1], child)
	
	func _setNodes(var old_root, var name, var game_tree):
		tree = game_tree
		root = node.new(old_root.getHex(), name, tree, ref)
		_setNodesHelper(root, old_root)
	
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
		retTree._setNodes(tree.getRoot(), name, tree.getTree())
		var x = 0
		return retTree
	return null