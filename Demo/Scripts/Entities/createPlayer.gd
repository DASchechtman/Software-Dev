extends Node

class Player extends "Entity.gd":
	
	func _init(var player_sprite, var health, var mana):
		sprite = player_sprite
		weakRefSprite = weakref(sprite)
		hp = health
		mp = mana
		moved = sprite.get_pos()

func new(var sprite, var hp, var mp):
	return Player.new(sprite, hp, mp)
