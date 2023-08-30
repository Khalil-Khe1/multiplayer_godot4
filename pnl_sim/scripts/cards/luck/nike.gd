extends Card

func _init():
	default_init()
	id = 1
	title = "nike air msh gucci"
	description = "step forward one square"
	count = 4
	tier = 1

func on_activate():
	var current : Player = get_node("/root/server/gamescene").get_current()
	current.move_to(current.get_square() + 1)
