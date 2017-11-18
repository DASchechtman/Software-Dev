extends Node

# this class will add a sprite to the screen
# the interpreter will use this class to create references
# to enemies in the game to use for various reasons
class Enemy extends "Entity.gd":
	
	func _init(var tree, var hp, var mp, var x, var y, var texture):
		var root = tree.get_root()
		var cur_scene = root.get_child(root.get_child_count()-1)
		sprite = Sprite.new()
		sprite.set_pos(Vector2(x, y))
		sprite.set_texture(texture)
		cur_scene.call_deferred("add_child", sprite)
		self.hp = hp
		self.mp = mp
		weakRefSprite = weakref(sprite)
		moved = sprite.get_pos()

static func createEnemy(var tree, var hp, var mp, var x, var y, var texture):
	return Enemy.new(tree, hp, mp, x, y, texture)