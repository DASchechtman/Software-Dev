extends TextureProgress

func _ready():
	set_value(100)

func change(var val):
	set_value(val)

func recover(var player):
	var recover_amt = 1/OS.get_frames_per_second()
	if player.get_mana() < 100:
		player.set_mana(player.get_mana() + recover_amt)
