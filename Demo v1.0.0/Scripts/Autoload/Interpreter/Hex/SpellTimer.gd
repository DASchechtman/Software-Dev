extends Reference

# this class will be used in the Hex
# class to trigger the hex, and run the
# spell until it is supposed to end
var ref_hex
var cast_textures = null
var cur_scene = null
var ref
var scene_root
var thread
var visable_spell_loader = preload("ShowSpell.gd")
var visable_spell = {}
var cast = false

func _init(var refered_hex, var root, var count):
	cast_textures = {
		Fire = load("res://Art/Fire.tex"),
		Water = load("res://Art/Water.tex"),
		Earth = load("res://Art/Earth.tex"),
		Air = load("res://Art/Air.tex")
	}
	scene_root = root
	ref_hex = refered_hex
	ref = count
	thread = Thread.new()

func getHex():
	return ref_hex

func cast(var x, var y):
	ref.set(ref.get()+1)
	var scene = scene_root.get_child(scene_root.get_child_count()-1)
	var size = visable_spell.size()
	visable_spell[size] = visable_spell_loader.new(x, y, cast_textures[ref_hex.Element()], ref_hex.Time(), scene, self, size)
	visable_spell[size].start()
	
func updatePos(var x, var y):
	for spell in visable_spell:
		visable_spell[spell].updatePos(x, y)

func destroy(var index):
	ref.set(ref.get()-1)
	visable_spell[index].stop()
	visable_spell.erase(index)