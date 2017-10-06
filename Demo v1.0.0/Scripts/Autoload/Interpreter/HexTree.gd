extends Node

#This will be a node in the hex tree
class HexNode:
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


#This class will be used to store Hex objects
#in a tree like fashion in memory
#This will make accessing each spell
#pretty quick, and if I decide to make a 
#file system for the game, then this will allow me
#to more easily structure it base off the
#hexes in computer memory
class HexTree:
	var root
	func _init(var hex, var name, var parser):
		root = HexNode.new(hex, name, parser)
		_createChildren(root, parser)
	
	func _createChildren(var node, var parser):
		# gets the list of spells stored in memory
		var spells = DataShare.get("CastList")
		
		for spell in node.getHex().Cast():
			
			# because null is stored as the same the first object
			# stored in all the Hex.Cast() list for some reason
			# and I am too lazy to try and find the bug, I just
			# added this line to fix bugs
			if spell == null:
				continue
				
			# Makes sure that if a spell name is the same as a keyword
			# it can be decoded properly to get the name of the
			# file
			if spells.has(spell+'_'):
				spell = spell + '_'
			var file = FileLoader.new('user://'+spell+'.hex', spell)
			var childHex = parser.compile(file, [])
			node.getChildList().push_back(HexNode.new(childHex, spell, parser))
			_createChildren(node.getChildList()[node.getChildList().size()-1], parser)
			
static func new(var hex, var name, var parser):
	return HexTree.new(hex, name, parser)