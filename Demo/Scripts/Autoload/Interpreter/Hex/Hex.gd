extends Reference

# the language of the game will have a very strict structure to it
# so I thought it be most effiecent if each keyword in the language
# has it's own key in a dictionary so specific values can be accessed
# quickly
var castParams = {}
var curKey = null
var spellName
var buffer = ""
var hex = null
var inc_list = null
var Inc_list = preload("res://Scripts/Autoload/Interpreter/Hex/IncreamentList.gd")


func _init(var name = "", var push = true):
	
	spellName = name
	
	# the start and end entries in castParams
	# will be used to make sure the program will be forced to follow a strict
	# structure
	castParams.start = null
	castParams.end = null
	
	# this will determine what type of effects this spell can have
	# each element has it's own unique behaviors that can be utilized
	castParams.Element = 'None'
	
	# determines how long (in seconds) the spell will last
	# Will be given a defualt value, if the player doesn't specify
	castParams.Time = 1
	
	# will determine how much power a spell will have
	# the higher this value, the more effective the spells
	# behavior will be, but will cost more mana
	# will be given a defualt value if not specified
	castParams.Power = 1.0
	
	# this will determine the specific behavior the spell will be able
	# to perform
	castParams.Action = null
	
	# will determine how far away from the caster the spell will take place
	# will be given a defualt value if not specified
	castParams.Distance = 1.0
	
	# this is the list of spells that will be cast
	# this list will contain the original spell as well
	# as any other spell the user has created and specified
	castParams.Cast = []
	
	castParams.If = []
	castParams.test = []
	
	if push:
		Stack.push(self)

func _createIf(var compiled_if):
	var PATH = "res://Scripts/Autoload/Interpreter/If Statements/"
	var if_types = {
		mana = {
			'less than': PATH + "IfManaLessThen.gd",
			'greater than': PATH + "IfManaGreaterThen.gd"
		},
		hp = {
		}
	}
	var type = null
	var action = null
	if compiled_if.getType() != null:
		type = compiled_if.getType()
	if compiled_if.getAction() != null:
		action = compiled_if.getAction()
		
	var made_if = null
	if type != null and action != null and compiled_if.getData() != null:
		var hex = get_script()
		made_if = load(if_types[type][action]).new(compiled_if.getData(), hex.new())

	return made_if


func add(var key, var value):
	# makes sure no new fields in the hex object
	# is added in case when this method is called
	if castParams.has(key):
		if typeof(castParams[key]) == typeof([]) and value != null:
			castParams[key].push_back(value)
		elif typeof(castParams[key]) != typeof([]):
			castParams[key] = value
		

func set(var key, var keyType):
	"""
	this if/else statement will act like a switch
	because of how a spell script is structured 
	it's Keyword: Keyword. Where the first keyword is a key in the 
	dictionary. and the second keyword is the a value
	stored in that dictionary key. This if/else statement will 
	check if the hex object has seen the first keyword and remembers
	it, then the next time this method is called, it will assume the key
	passed in is the value to be stored into the key that was
	passed in last time.
	"""
	
	hex = Stack.get()
	
	if typeof(key) != typeof(0) and typeof(key) != typeof(0.0) and key == 'if':
		var if_condition = _createIf(keyType)
		if if_condition != null and hex == self:
			castParams.If.push_back(Inc_list.new())
			castParams.If[castParams.If.size()-1].add(if_condition)
		elif if_condition != null:
			castParams.If[castParams.If.size()-1].add(if_condition)
		Stack.get().add("start", "point")
		return
		
	if keyType == "Spell":
		hex.add(curKey, key)
	elif curKey != null and castParams.has(curKey):
		if buffer != "Spell":
			if curKey == "end" and key == "point":
				Stack.pop()
			hex.add(curKey, key)
			curKey = null
		else:
			hex.add(key, null)
			curKey = key
	else:
		hex.add(key, null)
		curKey = key
	buffer = keyType

#below are getter functions
func curKey():
	return curKey

func Element():
	return castParams.Element

func Time():
	return castParams.Time

func Power():
	return castParams.Power

func Action():
	return castParams.Action

func Distance():
	return castParams.Distance

func Cast():
	return castParams.Cast
	
func Name():
	return spellName

func Start():
	return castParams.start

func End():
	return castParams.end

func Ifs():
	return castParams.If