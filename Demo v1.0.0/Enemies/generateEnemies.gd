extends Node

# this class will add a sprite to the screen
# the interpreter will use this class to create references
# to enemies in the game to use for various reasons
class Enemy extends Reference:
	
	# this will be the enemy that is displayed on the screen
	var sprite
	
	# when changing scenes, sprite will be freed from memory
	# and can't be checked for null value, this will allow
	# for a null value to be checked to keep the program from crashing
	var weakRefSprite
	
	func _init(var tree, var x, var y, var texture, var name):
		
		# gets the current scene on the screen to
		# display the enemy
		var root = tree.get_root()
		var scene = root.get_child(root.get_child_count()-1)
		
		# this will hold the texture and position of the enemy
		sprite = Sprite.new()
		sprite.set_pos(Vector2(x, y))
		sprite.set_texture(texture)
		
		# adds the enemy to the scene
		scene.call_deferred("add_child", sprite)
		
		# creates a weak reference to safely check
		# if operatons on sprite can be made
		weakRefSprite = weakref(sprite)
	
	func getSprite():
		if weakRefSprite.get_ref() != null:
			return sprite.get_pos()
		return null
	
	func set_pos(var vec2):
		if weakRefSprite.get_ref() != null:
			sprite.set_pos(vec2)
		
	func get_pos():
		if weakRefSprite.get_ref() != null:
			return sprite.get_pos()
		return null

static func createEnemy(var tree, var x, var y, var texture, var name):
	return Enemy.new(tree, x, y, texture, name)