extends Reference

enum {LESS_THAN = 0, LESS_THAN_OR_EQUAL_TO = 1, EQUALS = 2, GREATER_THAN = 3, GREATER_THAN_OR_EQUAL_TO = 4}

var name = null
var type = null
var action = null
var data = null

func _init(var condidtion_line = ", , , , , , , , , ,"):
	var parts = _split(condidtion_line)
	var start_of_if = parts[0].find("if")
	name = parts[0].substr(start_of_if, parts[0].length()-1)
	var keywords = DataShare.get("Keywords")
	if keywords.has(parts[2].capitalize()):
		if keywords.has(parts[1].capitalize()):
			type = parts[1]
		
		if keywords.has(parts[3].capitalize()) and keywords.has(parts[4].capitalize()):
			action = parts[3] + ' ' + parts[4]
		
		if float(parts[5]) != 0:
			data = float(parts[5])
		elif float(parts[5]) == 0 and parts[5] == '0':
			data = float(parts[5])

func _split(var line):
	var split_strs = []
	var single_str = ""
	for c in line:
		if c == ' ':
			split_strs.push_back(single_str.to_lower())
			single_str = ""
		else:
			single_str += c 
	split_strs.push_back(single_str)
	return split_strs

func getName():
	return name

func getType():
	return type

func getAction():
	return action

func getData():
	return data