extends "IfConBase.gd"

func _init(var comparison_data, var hex):
	init(comparison_data, hex)

func eval(var caster):
	var mana_level = caster.get_mana()
	var ret = 0 < caster.get_mana() and caster.get_mana() < comparison_data
	var debug = null
	return ret