extends Card

func _init():
	default_init()
	id = 1
	title = "adidas flair"
	description = "contact the soviets from any square"
	count = 2
	tier = 2

func on_activate():
	get_node("/root/server/gamescene").ui_land(get_node("/root/server/gamescene").get_shares().find(17))
