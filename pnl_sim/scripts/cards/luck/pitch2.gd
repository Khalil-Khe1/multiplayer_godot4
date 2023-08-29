extends Card

func _init():
	default_init()
	id = 1
	title = "courtesy of the streets"
	description = "50% profit on sales for the next 5 turns"
	count = 1
	tier = 3

func on_activate():
	var current : Player = get_node("/root/server/gamescene").get_current()
	current.append_boost(0.5, 5)
