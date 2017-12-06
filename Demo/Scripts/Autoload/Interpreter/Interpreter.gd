extends Node

var parser = _getInstance(preload("Parser.gd"))
const spell_tree = preload("HexTree.gd")

# this will hold a reference to all the enemy objects
# and the player objects in the level so that the interpreter
# can manipulate them
var gameObjects = {}

# stores the data for every enemy that will be affected by the spell
# being cast
var spellCasts = []

var first_run = null

# this method will be used to moderate how the spell affects the
# game world.
func updateSpells():
	
	# makes sure that the index in the for loop
	# aligns with the elements in spellCast
	# to allow for save removal of spells
	# when the spells are no longer running
	var offset = 0
	
	# keeps the loop the same size 
	var remove = []
	
	
	for i in spellCasts:
		
		# makes it easier to access the data in
		# each element of spellCast
		var cast_spell = i[0][1]
		var caster_sprite = i[0][0]
		var enemy_sprite = i[1][0]
	
		if cast_spell.isActive():
			
			cast_spell.eval(caster_sprite)
			
			# there were problems with enemies dying when they
			# were supposed to die when this was its own 
			# if condition, so I decided to place this if condidtion here
			if caster_sprite.get_mana() <= 0:
				remove.push_back(i)
				cast_spell.stop()
				caster_sprite.stop_using_mana()
			
			
			# gets the position of the enemy so the spell
			# sprites will be drawn on top of the enemy
			var targetPos = enemy_sprite.get_pos()
			
			# damage in the game will be calculated as the power of the spell
			# casted per second per target affected
			# by the spell, therefore to keep this consistent. I will get
			# the fps of the game. The same goes for mana useage
			var damage = cast_spell.getDamage()/OS.get_frames_per_second()
			
			caster_sprite.use_mana(damage)
			
			if caster_sprite.get_mana() > 0:
				enemy_sprite.takeDamage(damage)
			elif first_run:
				caster_sprite.takeDamage(-caster_sprite.get_mana())
			
			if enemy_sprite.isMoving():
				cast_spell.updatePos(targetPos.x, targetPos.y)
				
			if enemy_sprite.hasNoMoreHealth():
				# these will get rid of the enemy in memory
				# by getting rid of the references stored
				# by the interpreter and global list
				
				# these if statements may not be nessecary
				# but it doesn't hurt to keep them there just
				# incase they catch bugs
				if gameObjects["Enemies"].has(enemy_sprite):
					gameObjects["Enemies"].erase(enemy_sprite)
				
				if DataShare.get("EnemiesList").has(enemy_sprite):
					DataShare.get("EnemiesList").erase(enemy_sprite)
				
				# frees the sprite stored in an Enemy Object
				# from memory
				enemy_sprite.destroy()
				
				# stops the spell from running as soon as the enemy dies
				cast_spell.stop()
				caster_sprite.stop_using_mana()
		elif !cast_spell.isActive():
			remove.push_back(i)
			caster_sprite.stop_using_mana()
			
		for i in remove:
			spellCasts.erase(i)
		first_run = false

# removes the local reference of the data needed to determine how a spell
# interacts with the game world and shuts the spell off
func _deactivate_spell(var i, var offset, var spellCast, var caster_sprite):
	spellCasts.erase(spellCasts[i-offset])
	offset += 1
	caster_sprite.stop_using_mana()
	return offset

# clears all the references the interpreter holds from memory
# this function may be removed further in development
func clear():
	gameObjects.clear()

# turns the script that the player makes in the game
# into an hex tree object that the computer can more easily use
func compile(var file, var caster):
	var hex = parser.compile(file)
	if hex.Start() == 'point' and hex.End() == 'point':
		if caster == "Player":
			gameObjects[caster][1] = spell_tree.new(hex, file.getName(), parser, get_tree().get_root())
		else:
			gameObjects["Enemies"][caster][1] = spell_tree.new(hex, file.getName(), parser, get_tree().get_root())

# this will take the spell that the player and enemies
# turned into an object, and add it to spellCast so the
# interpreter can decide how the spell will behave
# NOTE: CURRENTLY ONLY FUNCTIONALITY FOR THE PLAYER ATTACKING
# THE ENEMY IS WORKING, ENEMIES ATTACKING PLAYER WILL BE ADDED
# AT A LATER DATE
func cast(var enemy):
	if typeof(enemy) == typeof("String") and enemy == "Player":
		pass
	else:
		var cloned_player = [gameObjects["Player"][0], spell_tree.clone(gameObjects["Player"][1])]
		var list = [cloned_player, gameObjects["Enemies"][enemy]]
		var pos = gameObjects["Enemies"][enemy][0].get_pos()
		if cloned_player[1] != null:
			spellCasts.push_back(list)
			cloned_player[1].cast(pos.x, pos.y)
			first_run = true

func stop():
	for spell in spellCasts:
		spell[0][1].stop()

func createEnemy(var x, var y, var hp, var mp, var texture):
	if !gameObjects.has("Enemies"):
		gameObjects["Enemies"] = {}
	var enemy = generateEnemies.createEnemy(get_tree(), hp, mp, x, y, load("res://icon.png"))
	gameObjects["Enemies"][enemy] = [enemy, null]
	return enemy

func createPlayer(var sprite, var hp, var mp):
	var player = createPlayer.new(sprite, hp, mp)
	if !gameObjects.has("Player"):
		gameObjects["Player"] = [player, null]
	else:
		gameObjects["Player"][0] = player
	return player

func _getInstance(var object, var parameter = null, var giveParams = false):
	if giveParams:
		object = object.new(parameter)
	else:
		object = object.new()
	return object