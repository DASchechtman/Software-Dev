extends Reference

var comparison_data
var hex

func init(var comparison_data, var hex):
	self.comparison_data = comparison_data
	self.hex = hex

func eval(var caster):
	pass
	
func getHex():
	return hex