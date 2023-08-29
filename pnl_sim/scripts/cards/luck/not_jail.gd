extends Card

func _init():
	default_init()
	id = 1
	title = "classic schmosby"
	description = "get out of jail"
	count = 2
	tier = 1

func on_activate():
	var current : Player = get_node("/root/server/gamescene").get_current()
	current.set_is_imprisoned(false)
