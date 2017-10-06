extends Node

# This class will add additional functionality to
# the Hex class. I decided to make the game store the
# spells the player makes in a tree like structure. 
# That way I can more easily make a file system
# based off how the spells are stored in memory
class HexNode extends Node:
	var nodeName
	var childrenNames
	var hex
	
	func _init(var hex, var name, var parser):
		self.hex = hex
		nodeName = name
		childrenNames = []
	
	func getNodeName():
		return nodeName
		
	func getChildrenName():
		return childrenNames
		
	func getChildList():
		return childrenNames
		
	func getHex():
		return hex
	
	func addChildName(var name):
		childrenNames.push_back(name)
		
	func hasChild(var name):
		return childrenNames.has(name)
		
class HexTree:
	var root
	func _init(var hex, var name, var parser):
		root = HexNode.new(hex, name, parser)
		_createChildren(root, parser)
	
	func _createChildren(var node, var parser):
		var spells = DataShare.get("CastList")
		for spell in node.getHex().Cast():
			if spell == null:
				continue
			if spells.has(spell+'_'):
				spell = spell + '_'
			var file = FileLoader.new('user://'+spell+'.hex', spell)
			var childHex = parser.compile(file, [])
			node.getChildList().push_back(HexNode.new(childHex, spell, parser))
			_createChildren(node.getChildList()[node.getChildList().size()-1], parser)
			
static func new(var hex, var name, var parser):
	return HexTree.new(hex, name, parser)