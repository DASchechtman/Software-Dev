extends Node

#This will be a node in the hex tree
class HexNode extends Reference:
	
	# this is the spell template that will be used to create
	# each new spell in the tree
	const hex_timer = preload("Hex/SpellTimer.gd")
	
	var nodeName
	
	# this stores each new spell as a child
	# of the spell that is calling all the other 
	# spells
	var childrenNames
	var spell
	
	func _init(var hex, var name, var root, var count):
		spell = hex_timer.new(hex, root, count)
		nodeName = name
		
		# holds all the children of the node
		# not a string of each node name
		childrenNames = []
	
	func updatePos(var x, var y):
		spell.updatePos(x, y)
	
	func stop():
		spell.stop()
	
	func cast(var x, var y):
		spell.cast(x, y)
	
	func getNodeName():
		return nodeName
	
	# returns all of the children nodes for 
	# the node that has this method called
	func getChildList():
		return childrenNames
	
	func getHex():
		return spell.getHex()
	
	func addChildName(var name):
		childrenNames.push_back(name)
		
	func hasChild(var name):
		var hasChild = false
		for child in childrenNames:
			if name == child.getNodeName():
				hasChild = true
				break
		return hasChild

static func new(var hex, var name, var root, var count):
	return HexNode.new(hex, name, root, count)