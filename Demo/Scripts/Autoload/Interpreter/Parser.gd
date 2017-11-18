extends Reference

# allows me to make new tokens and hex objects
const TOKEN = preload("Token.gd")
const HEX = preload("Hex/Hex.gd")

# used to make a list of tokens
# it made more sense to find all the
# tokens in each line and seperate them
# according to the line they where
# created from
var listToks
var spellName
const referance = preload("res://Scripts/ReferanceVars/RefVar.gd")


func _init():
	listToks = []

func compile(var file):
	var spellList = []
	# will get each line from the hex file, and
	# and processes it into it's individual tokens
	for line in file.read():
		# keeps track of the index of the line
		# being processed. This allows for me to
		# know when the end of the line has been 
		# reached
		var ref = referance.new(0)
		
		var tokList = []
		var buffer = ""
		
		# keep going til the end of the line
		while ref.get() < line.length():
			
			var tokenName = _findName(line, ref)
			if buffer == 'Element':
				tokenName = _fixElementInput(tokenName)
			var keyword = DataShare.get("Keyword")
			
			if keyword.has(tokenName) and buffer != "Cast":
				tokList.push_back(TOKEN.new(tokenName, keyword[tokenName]))
			elif _checkIfNumber(tokenName):
				var num = ""
				for char in tokenName:
					if _checkIfNumber(char) or char == '.':
						num += char
				num = convertToNum(buffer, num)
				tokList.push_back(TOKEN.new(num, "Number"))
			elif !tokenName.empty() and buffer == 'Cast':
				tokList.push_back(TOKEN.new(fixInputData(buffer, tokenName), "Spell"))
			elif tokenName.empty() and buffer == 'Cast':
				tokList.push_back(TOKEN.new("*", "Spell"))
				
			if tokList.size() > 0:
				if ((buffer == 'Cast' and tokList[tokList.size()-1].getVal() != 'Spell') 
				or buffer.empty()):
					buffer = tokList[tokList.size()-1].getName()
		spellList.push_back(tokList)
	return _convertToHex(spellList)
	
func _findName(var line, var ref):
	var getName = ""
	var char = line[ref.get()]
	while char != ':' and char != ' ' and char != '\t' and char != ',':
		getName += char
		ref.set(ref.get()+1)
		if ref.get() == line.length():
			break
		char = line[ref.get()]
	
	ref.set(ref.get() + 1)
		
	return getName

func convertToNum(var token_name, var string_num):
	if token_name == 'Time':
		string_num = int(string_num)
		if string_num == 0:
			string_num = 1
	else:
		string_num = float(string_num)
		
	return string_num

func _fixElementInput(var element):
	if element.to_lower() == 'fire':
		element = 'Fire'
	elif element.to_lower() == 'water':
		element = 'Water'
	elif element.to_lower() == 'earth':
		element = 'Earth'
	elif element.to_lower() == 'air':
		element = 'Air'
	return element

func fixInputData(var token_name, var data):
	if token_name == 'Time':
		data = 1
	elif token_name == 'Power' or token_name == 'Distance':
		data = 1.0
	elif token_name == 'Element':
		data = 'Fire'
	return data

func _checkIfNumber(var line):
	var is_num = false
	if !line.empty():
		if line[0] >= '0' and line[0] <= '9':
			is_num = true
		elif line.length() > 1:
			if line[0] == '-' and line[1] >= '0' and line[1] <= '9':
				is_num = true
			elif line[0] == '.' and line[1] >= '0' and line[1] <= '9':
				is_num = true
	return is_num
	
func _convertToHex(var tokList):
	var hex = HEX.new(spellName)
	for tokens in tokList:
		var isList = false
		for token in tokens:
			#set(var key) has the ability to save a key
			#passed in. The end result is that the first time
			#set(var key) is called it saves the key
			#passed to it, and the second time set(var key)
			#is called it uses that stored key to get access
			#to the correct element in hex's internal dictionary
			#and stores the key passed in to that dictionary
			var name = token.getName()
			var type = token.getVal()
			hex.set(token.getName(), token.getVal())
	return hex