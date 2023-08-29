extends Card

func _init():
	default_init()
	id = 1
	title = "catch me if you can"
	description = "clean your heat levels"
	count = 2
	tier = 2

func on_activate():
	get_node("/root/server/gamescene").get_current().set_stars(0)
