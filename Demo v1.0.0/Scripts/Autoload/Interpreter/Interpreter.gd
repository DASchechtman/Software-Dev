extends Node

var parser = _getInstance(preload("Parser.gd"))
var spell_tree = preload("HexTree.gd")
var spells = {}

func compile(var file, var caster):
	if !spells.has(caster):
		spells[caster] = {}
		
	spells[file.getName()] = spell_tree.new(parser.compile(file, []), caster, parser)
	
	
func _getInstance(var object, var parameter = null, var giveParams = false):
	if giveParams:
		object = object.new(parameter)
	else:
		object = object.new()
	return object
	