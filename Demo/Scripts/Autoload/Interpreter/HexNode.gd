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
	var hex
	var root
	var count
	var if_con = []
	var if_spells = {}
	
	func _init(var hex, var name, var root, var count):
		spell = hex_timer.new(hex, root, count)
		nodeName = name
		self.hex = hex
		self.root = root
		self.count = count
		
		# holds all the children of the node
		# not a string of each node name
		childrenNames = []
		_readInIfs()
	
	func updatePos(var x, var y):
		spell.updatePos(x, y)
		for spells in if_spells:
			if_spells[spells].updatePos(x, y)
	
	func stop():
		spell.stop()
		for spells in if_spells:
			if_spells[spells].stop()
		if_spells.clear()
	
	func cast(var x, var y):
		spell.cast(x, y)
	
	func eval(var x, var y, var caster, var damage):
		for i in if_con:
			i.set(0)
			var eval_result = i.get().eval(caster)
			while i.hasNext() and eval_result:
				if not if_spells.has(i.get()):
					if_spells[i.get()] = hex_timer.new(i.get().getHex(), root)
				if i.get().getHex().Element() != "None":
					damage.set(damage.get() + i.get().getHex().Power())
				if_spells[i.get()].cast(x, y)
				i.next()
				if i.get() != null:
					eval_result = i.get().eval(caster)
					hex = i.get().getHex()
			
			if not eval_result and if_spells.has(i.get()):
				if_spells[i.get()].stop()
				if_spells.erase(i.get())
	
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
	
	func _readInIfs():
		for i in hex.Ifs():
			if_con.push_back(i)

static func new(var hex, var name, var root, var count):
	return HexNode.new(hex, name, root, count)