extends "IfConBase.gd"

func _init(var comparison_data, var hex):
	init(comparison_data, hex)
	
func eval(var caster):
	return caster.get_mana() > comparison_data
