extends Card

func _init():
	default_init()
	id = 1
	title = "sales pitch"
	description = "20% profit increase for the next 5 turns"
	count = 4
	tier = 1

func on_activate():
	var current : Player = get_node("/root/server/gamescene").get_current()
	current.append_boost(0.2, 5)
