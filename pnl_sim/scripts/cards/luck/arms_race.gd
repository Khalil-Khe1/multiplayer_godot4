extends Card

func _init():
	default_init()
	id = 1
	title = "arms race"
	description = "generate 25x arms per turn (avec x nombre de copies de cette carte)"
	count = 4
	tier = 2

func on_activate():
	pass
	#come back to this when you do contracts
