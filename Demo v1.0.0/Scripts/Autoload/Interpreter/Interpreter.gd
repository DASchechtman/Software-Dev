extends Node

var parser = _getInstance(preload("Parser.gd"))
const spell_tree = preload("HexTree.gd")
var spells = {}
var gameObjects = {}
var enemy_index = 0
var spellCasts = []
var thread

func _ready():
	thread = Thread.new()
	thread.start(self, "_run")

func _run(data):
	while true:
		var offset = 0
		var size = spellCasts.size()
		for i in range(size):
			var cast_spell = spellCasts[i-offset][0][1]
			var sprite = spellCasts[i-offset][1][0]
			if cast_spell != null and cast_spell.isActive():
				var targetPos = sprite.get_pos()
				if targetPos != null:
					spellCasts[i-offset][0][1].updatePos(targetPos.x, targetPos.y)
			else:
				spellCasts.remove(i-offset)
				offset += 1

func clear():
	gameObjects["Player"][1] = null
	for enemy in gameObjects["Enemies"]:
		gameObjects["Enemies"][enemy][1] = null

func compile(var file, var caster):
	var hex = parser.compile(file)
	if caster == "Player":
		gameObjects[caster][1] = spell_tree.new(hex, file.getName(), parser, get_tree().get_root())
	else:
		gameObjects["Enemies"][caster][1] = spell_tree.new(hex, file.getName(), parser, get_tree().get_root())
	
func cast(var enemy):
	if typeof(enemy) == typeof("String") and enemy == "Player":
		spellCasts.push_back(gameObjects["Player"])
	else:
		var cloned_player = [gameObjects["Player"][0], spell_tree.clone(gameObjects["Player"][1])]
		var list = [cloned_player, gameObjects["Enemies"][enemy]]
		if !spellCasts.has(list):
			spellCasts.push_back(list)
		var pos = gameObjects["Enemies"][enemy][0].get_pos()
		if cloned_player[1] != null:
			cloned_player[1].cast(pos.x, pos.y)

func createEnemy(var x, var y, var texture):
	if !gameObjects.has("Enemies"):
		gameObjects["Enemies"] = {}
	var enemy = generateEnemies.createEnemy(get_tree(), x, y, preload("res://icon.png"), str("Enemy_", enemy_index))
	gameObjects["Enemies"][enemy] = [enemy, null]
	enemy_index += 1
	return enemy
	

func createPlayer(var sprite):
	if !gameObjects.has("Player"):
		gameObjects["Player"] = [sprite, null]

func _getInstance(var object, var parameter = null, var giveParams = false):
	if giveParams:
		object = object.new(parameter)
	else:
		object = object.new()
	return object
	