extends Reference

var sprite
var weakRefSprite
var hp
var mp
var moved
var in_use = false
	
func takeDamage(var damage):
		hp -= damage
	
func hasNoMoreHealth():
	return hp <= 0
	
func getHP():
	return hp
	
func destroy():
	if weakRefSprite.get_ref() != null:
		sprite.queue_free()
	
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

func isMoving():
	var hasMoved = false
	if weakRefSprite.get_ref() != null:
		hasMoved = ((moved.x != sprite.get_pos().x) or (moved.y != sprite.get_pos().y))
		if !hasMoved:
			moved = sprite.get_pos()
	return hasMoved

func is_using_magic():
	return in_use
	
func get_mana():
	return mp

func set_mana(var mana):
	mp = mana
	
func use_mana(var mp_used):
	if mp > 0:
		in_use = true
		mp -= mp_used
	else:
		mp = 0
	
func stop_using_mana():
	in_use = false