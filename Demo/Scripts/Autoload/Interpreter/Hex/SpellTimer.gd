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
var visable_spell
var weak_spell_ref
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

func getHex():
	return ref_hex

func cast(var x, var y):
	ref.set(ref.get()+1)
	var scene = scene_root.get_child(scene_root.get_child_count()-1)
	visable_spell = visable_spell_loader.new(x, y, cast_textures[ref_hex.Element()], ref_hex.Time(), scene, self)
	weak_spell_ref = weakref(visable_spell)
	visable_spell.start()

func updatePos(var x, var y):
	if weak_spell_ref.get_ref() != null:
		visable_spell.updatePos(x, y)

func destroy():
	if weak_spell_ref.get_ref() != null:
		ref.set(ref.get()-1)
		visable_spell.stop()
		visable_spell = null
	
func stop():
	if weak_spell_ref.get_ref() != null:
		destroy()