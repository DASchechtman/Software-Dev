extends Node

# the language of the game will have a very strict structure to it
# so I thought it be most effiecent if each keyword in the language
# has it's own key in a dictionary so specific values can be accessed
# quickly
var castParams = {}
var curKey = null
var spellName
var buffer = ""

func _init(var name):
	
	spellName = name
	
	# the start and end entries in castParams
	# will be used to make sure the program will be forced to follow a strict
	# structure
	castParams.start = null
	castParams.end = null
	
	# this will determine what type of effects this spell can have
	# each element has it's own unique behaviors that can be utilized
	castParams.Element = null
	
	# determines how long (in seconds) the spell will last
	# Will be given a defualt value, if the player doesn't specify
	castParams.Time = 1
	
	# will determine how much power a spell will have
	# the higher this value, the more effective the spells
	# behavior will be, but will cost more mana
	# will be given a defualt value if not specified
	castParams.Power = 1
	
	# this will determine the specific behavior the spell will be able
	# to perform
	castParams.Action = null
	
	# will determine how far away from the caster the spell will take place
	# will be given a defualt value if not specified
	castParams.Distance = 1
	
	# this is the list of spells that will be cast
	# this list will contain the original spell as well
	# as any other spell the user has created and specified
	castParams.Cast = []
	
func add(var key, var value):
	# makes sure no new fields in the hex object
	# is added in case when this method is called
	if castParams.has(key):
		if typeof(castParams[key]) == typeof([]):
			castParams[key].push_back(value)
		else:
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
	if keyType == "Spell":
		add(curKey, key)
	elif curKey != null and castParams.has(curKey):
		if buffer != 'Spell':
			add(curKey, key)
			curKey = null
		else:
			add(key, null)
			curKey = key
	else:
		add(key, null)
		curKey = key
	buffer = keyType
func printAll():
	for el in castParams:
		print(el, ' : ', castParams[el])

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